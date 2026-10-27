#Requires -Version 5.1
<#
.SYNOPSIS
    Makes everything in ~/.opencode available in every project, for both Claude Code
    and OpenCode, and keeps it current.

.DESCRIPTION
    ~/.opencode stays the single source of truth (it's the git repo). This script:

      Skills  Every SKILL.md under ~/.opencode/skills (nested libraries included) gets a
              directory junction in ~/.claude/skills/<name>. Claude Code reads that folder,
              and so does OpenCode, so one link serves both. Junctions point at the real
              folder, so edits and `git pull` show up instantly; re-run only to pick up
              new or removed skills.
      Crews   ~/.opencode/agent/*.md is copied to ~/.config/opencode/agents/ as-is and to
              ~/.claude/agents/ converted to Claude Code's subagent format.
      Rules   GLOBAL-RULES.md is written into a marked block in ~/.claude/CLAUDE.md and
              ~/.config/opencode/AGENTS.md. Text outside the block is never touched.
      MCP     Servers in ~/.opencode/opencode.json are merged into
              ~/.config/opencode/opencode.json and registered in Claude Code at user scope.

    It only ever replaces or removes things it created itself (junctions into
    ~/.opencode/skills, files carrying the sync marker). Anything else with the same
    name, such as gstack's skills, is left alone and reported as a conflict.

    Skill names listed in skills-exclude.txt (next to this script) are never linked.

.EXAMPLE
    .\sync-global.ps1 -DryRun        # show what would change, change nothing
    .\sync-global.ps1                # sync now
    .\sync-global.ps1 -Pull          # git pull ~/.opencode first, then sync
    .\sync-global.ps1 -RegisterTask  # also run "-Pull" every day at 12:00
    .\sync-global.ps1 -ReplaceCopies # move old copied skill folders out of ~/.claude/skills
                                     # (to ~/.claude/skills-backup/<time>) and link them instead.
                                     # gstack's skills are never touched.
#>
[CmdletBinding()]
param(
    [switch]$Pull,
    [switch]$RegisterTask,
    [switch]$NoMcp,
    [switch]$ReplaceCopies,
    [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root      = $PSScriptRoot
$SkillsSrc = Join-Path $Root 'skills'
$AgentsSrc = Join-Path $Root 'agent'
$RulesSrc  = Join-Path $Root 'GLOBAL-RULES.md'
$McpSrc    = Join-Path $Root 'opencode.json'

$ClaudeDir    = Join-Path $HOME '.claude'
$ClaudeSkills = Join-Path $ClaudeDir 'skills'
$ClaudeAgents = Join-Path $ClaudeDir 'agents'
$ClaudeMd     = Join-Path $ClaudeDir 'CLAUDE.md'
$OcDir        = Join-Path $HOME '.config\opencode'
$OcAgents     = Join-Path $OcDir 'agents'
$OcAgentsMd   = Join-Path $OcDir 'AGENTS.md'
$OcConfig     = Join-Path $OcDir 'opencode.json'

$Marker = 'synced-from-dotopencode'
$Utf8   = New-Object System.Text.UTF8Encoding($false)

$LogDir = Join-Path $env:LOCALAPPDATA 'dotopencode-sync'
New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
try { Start-Transcript -Path (Join-Path $LogDir 'last-run.log') -Force | Out-Null } catch { }

$script:conflicts = New-Object System.Collections.Generic.List[string]
$script:dupes     = New-Object System.Collections.Generic.List[string]
$script:stats     = @{ linked = 0; unlinked = 0; agents = 0; agentsRemoved = 0 }

# ---------- helpers ----------

function Read-Text([string]$path) {
    return [IO.File]::ReadAllText($path).TrimStart([char]0xFEFF)
}

function Write-Text([string]$path, [string]$text) {
    if ($DryRun) { Write-Host "  [dry-run] would write $path"; return }
    $dir = Split-Path $path -Parent
    if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    [IO.File]::WriteAllText($path, $text, $Utf8)
}

function Get-Frontmatter([string]$text) {
    $m = [regex]::Match($text, '^\s*---\r?\n(.*?)\r?\n---[ \t]*\r?\n?(.*)$',
        [Text.RegularExpressions.RegexOptions]::Singleline)
    if (-not $m.Success) { return $null }
    return @{ Head = $m.Groups[1].Value; Body = $m.Groups[2].Value }
}

function ConvertTo-SkillName([string]$raw) {
    $n = ($raw.ToLower() -replace '[^a-z0-9-]+', '-').Trim('-')
    if ($n.Length -gt 64) { $n = $n.Substring(0, 64).Trim('-') }
    return $n
}

function Get-SkillName([string]$skillMd) {
    $fm = Get-Frontmatter (Read-Text $skillMd)
    if ($fm) {
        $m = [regex]::Match($fm.Head, '(?m)^name:\s*["'']?([^"''\r\n]+?)["'']?\s*$')
        if ($m.Success) {
            $n = ConvertTo-SkillName $m.Groups[1].Value
            if ($n) { return $n }
        }
    }
    return ConvertTo-SkillName (Split-Path (Split-Path $skillMd -Parent) -Leaf)
}

# '' = a real folder/file, $null = nothing there, otherwise the link target
function Get-LinkTarget([string]$path) {
    $item = Get-Item -LiteralPath $path -Force -ErrorAction SilentlyContinue
    if ($null -eq $item) { return $null }
    if (-not ($item.Attributes -band [IO.FileAttributes]::ReparsePoint)) { return '' }
    $t = [string](@($item.Target)[0])
    return ($t -replace '^\\\\\?\\|^\\\?\?\\', '')
}

function Test-Under([string]$path, [string]$root) {
    return $path -and $path.StartsWith($root.TrimEnd('\') + '\', [StringComparison]::OrdinalIgnoreCase)
}

function Set-MarkedBlock([string]$path, [string]$content) {
    $begin = "<!-- BEGIN $Marker : edit ~/.opencode/GLOBAL-RULES.md, not this block -->"
    $end   = "<!-- END $Marker -->"
    $block = "$begin`n$($content.Trim())`n$end"
    $cur = ''
    if (Test-Path -LiteralPath $path) { $cur = Read-Text $path }
    $rx = '(?s)<!-- BEGIN ' + [regex]::Escape($Marker) + '.*?<!-- END ' + [regex]::Escape($Marker) + ' -->'
    $m = [regex]::Match($cur, $rx)
    if ($m.Success) {
        $new = $cur.Substring(0, $m.Index) + $block + $cur.Substring($m.Index + $m.Length)
    } elseif ($cur.Trim()) {
        $new = $cur.TrimEnd() + "`n`n" + $block + "`n"
    } else {
        $new = $block + "`n"
    }
    if ($new -ne $cur) { Write-Text $path $new; Write-Host "  rules -> $path" }
}

function Write-Managed([string]$path, [string]$content, [string]$label) {
    if (Test-Path -LiteralPath $path) {
        $cur = Read-Text $path
        if ($cur -notmatch [regex]::Escape($Marker)) { $script:conflicts.Add("$label (existing file not made by this script)"); return }
        if ($cur -eq $content) { return }
    }
    Write-Text $path $content
    $script:stats.agents++
}

function ConvertTo-ClaudeAgent([IO.FileInfo]$file) {
    $fm = Get-Frontmatter (Read-Text $file.FullName)
    if (-not $fm) { return $null }
    $out = New-Object System.Collections.Generic.List[string]
    $out.Add('name: ' + (ConvertTo-SkillName $file.BaseName))
    $inDropped = $false
    $denyEdit = $false
    foreach ($line in ($fm.Head -split '\r?\n')) {
        # OpenCode-only keys: mode, OpenCode model ids, permission/tools blocks, temperature
        if ($line -match '^(name|mode|model|permission|tools|temperature|top_p|steps|color|hidden|disable)\s*:') {
            $inDropped = $true
            continue
        }
        if ($inDropped -and $line -match '^\s+\S') {
            if ($line -match '^\s+edit\s*:\s*deny') { $denyEdit = $true }
            continue
        }
        $inDropped = $false
        $out.Add($line)
    }
    if ($denyEdit) { $out.Add('disallowedTools: Edit, Write, NotebookEdit') }
    return "---`n" + ($out -join "`n") + "`n---`n<!-- $Marker -->`n" + $fm.Body
}

function Invoke-Native([string]$exe, [string[]]$argv) {
    # Windows PowerShell turns native stderr into errors under 'Stop'; keep it as plain output here.
    $prev = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try { $output = & $exe @argv 2>&1 | ForEach-Object { "$_" } }
    finally { $ErrorActionPreference = $prev }
    return @{ Code = $LASTEXITCODE; Output = ($output -join "`n") }
}

# ---------- 0. pull ----------

if ($Pull) {
    Write-Host "Pulling $Root ..."
    $r = Invoke-Native 'git' @('-C', $Root, 'pull', '--ff-only')
    Write-Host $r.Output
    if ($r.Code -ne 0) { Write-Warning 'git pull failed (local changes or diverged history). Syncing what is on disk.' }
}

# ---------- 1. skills ----------

Write-Host "`nSkills: $SkillsSrc -> $ClaudeSkills"
$skipRx = '\\(node_modules|\.git|graphify-out|__pycache__|templates?|examples?|assets|fixtures|tests?|evals?)\\|\.bak(\\|$)|\.old(\\|\.|$)'
$skillDirs = Get-ChildItem -LiteralPath $SkillsSrc -Recurse -Filter 'SKILL.md' -File -Force -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName.Substring($SkillsSrc.Length) -notmatch $skipRx } |
    ForEach-Object { $_.Directory.FullName } |
    Sort-Object -Property @{ Expression = { ($_ -split '\\').Count } }, @{ Expression = { $_ } } -Unique

$exclude = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
$ExcludeFile = Join-Path $Root 'skills-exclude.txt'
if (Test-Path -LiteralPath $ExcludeFile) {
    foreach ($line in ((Read-Text $ExcludeFile) -split '\r?\n')) {
        $n = ($line -replace '#.*$', '').Trim()
        if ($n) { [void]$exclude.Add($n) }
    }
}

# names gstack installed, so -ReplaceCopies never moves one of them
$gstackNames = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
[void]$gstackNames.Add('gstack')
$gstackRoot = Join-Path $ClaudeSkills 'gstack'
if (Test-Path -LiteralPath $gstackRoot) {
    foreach ($g in (Get-ChildItem -LiteralPath $gstackRoot -Directory -ErrorAction SilentlyContinue)) {
        $md = Join-Path $g.FullName 'SKILL.md'
        if (Test-Path -LiteralPath $md) {
            [void]$gstackNames.Add($g.Name)
            [void]$gstackNames.Add((Get-SkillName $md))
            [void]$gstackNames.Add('gstack-' + (Get-SkillName $md))
        }
    }
}

$wanted = @{}
$excludedCount = 0
foreach ($dir in $skillDirs) {
    $name = Get-SkillName (Join-Path $dir 'SKILL.md')
    if (-not $name) { continue }
    if ($exclude.Contains($name)) { $excludedCount++; continue }
    if ($wanted.ContainsKey($name)) {
        $script:dupes.Add("$name : kept $($wanted[$name].Substring($SkillsSrc.Length)), skipped $($dir.Substring($SkillsSrc.Length))")
    } else {
        $wanted[$name] = $dir
    }
}

if (-not $DryRun) { New-Item -ItemType Directory -Path $ClaudeSkills -Force | Out-Null }

# remove our links that are stale or point somewhere else now
if (Test-Path -LiteralPath $ClaudeSkills) {
    foreach ($entry in (Get-ChildItem -LiteralPath $ClaudeSkills -Force -Directory -ErrorAction SilentlyContinue)) {
        $t = Get-LinkTarget $entry.FullName
        if (-not (Test-Under $t $SkillsSrc)) { continue }
        $keep = $wanted.ContainsKey($entry.Name) -and ($wanted[$entry.Name] -eq $t) -and (Test-Path -LiteralPath $t)
        if (-not $keep) {
            if ($DryRun) { Write-Host "  [dry-run] would unlink $($entry.Name)" }
            else { [IO.Directory]::Delete($entry.FullName, $false) }   # removes the junction only, never the target
            $script:stats.unlinked++
        }
    }
}

$BackupDir = Join-Path $ClaudeDir ('skills-backup\' + (Get-Date -Format 'yyyyMMdd-HHmmss'))
$oldCopies = 0
$replaced = 0
foreach ($name in ($wanted.Keys | Sort-Object)) {
    $link = Join-Path $ClaudeSkills $name
    $t = Get-LinkTarget $link
    if ($null -ne $t -and $t -eq '' -and -not $gstackNames.Contains($name)) {
        # a plain folder: an old copy of one of your skills, frozen at the version it was copied
        if (-not $ReplaceCopies) { $oldCopies++; continue }
        if ($DryRun) { Write-Host "  [dry-run] would move old copy $name to $BackupDir and link it" }
        else {
            New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
            Move-Item -LiteralPath $link -Destination (Join-Path $BackupDir $name)
        }
        $replaced++
        $t = $null
    }
    if ($null -eq $t) {
        if ($DryRun) { Write-Host "  [dry-run] would link $name" }
        elseif (-not (Test-Path -LiteralPath $link)) { New-Item -ItemType Junction -Path $link -Target $wanted[$name] | Out-Null }
        $script:stats.linked++
    } elseif (-not (Test-Under $t $SkillsSrc)) {
        $script:conflicts.Add("skill '$name' (~/.claude/skills/$name belongs to gstack or another install)")
    }
}
Write-Host ("  {0} skills found, {1} newly linked, {2} unlinked, {3} excluded by skills-exclude.txt" -f $wanted.Count, $script:stats.linked, $script:stats.unlinked, $excludedCount)
if ($replaced) { Write-Host "  $replaced old copies moved to $BackupDir (delete that folder once you're happy)" }
if ($oldCopies) { Write-Host "  $oldCopies old copied folders in ~/.claude/skills won't update; run with -ReplaceCopies to link them instead" }

# ---------- 2. crews / agents ----------

Write-Host "`nCrews: $AgentsSrc"
$agentNames = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
if (Test-Path -LiteralPath $AgentsSrc) {
    foreach ($file in (Get-ChildItem -LiteralPath $AgentsSrc -Filter '*.md' -File)) {
        [void]$agentNames.Add($file.BaseName)
        $fm = Get-Frontmatter (Read-Text $file.FullName)
        if (-not $fm) { Write-Warning "  $($file.Name) has no frontmatter, skipped"; continue }

        $oc = "---`n" + $fm.Head + "`n---`n<!-- $Marker -->`n" + $fm.Body
        Write-Managed (Join-Path $OcAgents $file.Name) $oc "OpenCode agent $($file.Name)"

        $cc = ConvertTo-ClaudeAgent $file
        if ($cc) { Write-Managed (Join-Path $ClaudeAgents ($file.BaseName + '.md')) $cc "Claude agent $($file.Name)" }
    }
}
foreach ($dir in @($OcAgents, $ClaudeAgents)) {
    if (-not (Test-Path -LiteralPath $dir)) { continue }
    foreach ($f in (Get-ChildItem -LiteralPath $dir -Filter '*.md' -File)) {
        if ($agentNames.Contains($f.BaseName)) { continue }
        if ((Read-Text $f.FullName) -notmatch [regex]::Escape($Marker)) { continue }
        if ($DryRun) { Write-Host "  [dry-run] would remove $($f.FullName)" } else { Remove-Item -LiteralPath $f.FullName }
        $script:stats.agentsRemoved++
    }
}
Write-Host ("  {0} crews, {1} files written, {2} removed" -f $agentNames.Count, $script:stats.agents, $script:stats.agentsRemoved)

# ---------- 3. global rules ----------

Write-Host "`nRules: $RulesSrc"
if (Test-Path -LiteralPath $RulesSrc) {
    $rules = Read-Text $RulesSrc
    Set-MarkedBlock $ClaudeMd $rules
    Set-MarkedBlock $OcAgentsMd $rules
} else {
    Write-Warning '  GLOBAL-RULES.md not found, skipped'
}

# ---------- 4. MCP servers ----------

if (-not $NoMcp -and (Test-Path -LiteralPath $McpSrc)) {
    Write-Host "`nMCP: $McpSrc"
    $src = (Read-Text $McpSrc) | ConvertFrom-Json
    $servers = @()
    if ($src.PSObject.Properties['mcp']) { $servers = @($src.mcp.PSObject.Properties) }

    # 4a. OpenCode global config (merge, keep everything else)
    $oc = $null
    if (Test-Path -LiteralPath $OcConfig) {
        try { $oc = (Read-Text $OcConfig) | ConvertFrom-Json }
        catch { Write-Warning "  $OcConfig isn't plain JSON (comments?). Add the servers by hand." }
    } else {
        $oc = New-Object PSObject
        $oc | Add-Member -NotePropertyName '$schema' -NotePropertyValue 'https://opencode.ai/config.json'
    }
    if ($null -ne $oc) {
        if (-not $oc.PSObject.Properties['mcp']) { $oc | Add-Member -NotePropertyName 'mcp' -NotePropertyValue (New-Object PSObject) }
        $changed = $false
        foreach ($s in $servers) {
            $existing = $oc.mcp.PSObject.Properties[$s.Name]
            $before = if ($existing) { $existing.Value | ConvertTo-Json -Depth 20 -Compress } else { '' }
            $after  = $s.Value | ConvertTo-Json -Depth 20 -Compress
            if ($before -ne $after) { $oc.mcp | Add-Member -NotePropertyName $s.Name -NotePropertyValue $s.Value -Force; $changed = $true }
        }
        if ($changed) { Write-Text $OcConfig ($oc | ConvertTo-Json -Depth 20); Write-Host "  OpenCode -> $OcConfig" }
        else { Write-Host '  OpenCode already up to date' }
    }

    # 4b. Claude Code, user scope (available in every project)
    if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
        Write-Warning "  'claude' isn't on PATH; skipped Claude Code MCP registration"
    } else {
        foreach ($s in $servers) {
            $v = $s.Value
            if ($v.PSObject.Properties['enabled'] -and -not $v.enabled) { continue }
            $type = 'local'
            if ($v.PSObject.Properties['type']) { $type = $v.type }
            $envArgs = @()
            if ($v.PSObject.Properties['environment']) {
                foreach ($e in $v.environment.PSObject.Properties) { $envArgs += @('-e', "$($e.Name)=$($e.Value)") }
            }
            if ($type -eq 'local') {
                $cmd = @($v.command)
                # npx & co. are .cmd shims on Windows; Claude Code needs them wrapped in cmd /c
                if ($cmd[0] -match '^(npx|npm|pnpm|pnpx|bunx|yarn)(\.cmd)?$') { $cmd = @('cmd', '/c') + $cmd }
                $argv = @('mcp', 'add', '--scope', 'user') + $envArgs + @($s.Name, '--') + $cmd
            } elseif ($type -eq 'remote') {
                $argv = @('mcp', 'add', '--scope', 'user', '--transport', 'http', $s.Name, $v.url)
            } else { continue }

            if ($DryRun) { Write-Host "  [dry-run] would run: claude $($argv -join ' ')"; continue }
            [void](Invoke-Native 'claude' @('mcp', 'remove', $s.Name, '--scope', 'user'))
            $r = Invoke-Native 'claude' $argv
            if ($r.Code -eq 0) { Write-Host "  Claude Code -> $($s.Name)" }
            else { Write-Warning "  claude mcp add $($s.Name) failed: $($r.Output)" }
        }
    }
}

# ---------- 5. scheduled task ----------

if ($RegisterTask -and -not $DryRun) {
    Write-Host "`nScheduled task"
    try {
        $ps = (Get-Command powershell.exe).Source
        $action = New-ScheduledTaskAction -Execute $ps -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$PSCommandPath`" -Pull"
        $trigger = New-ScheduledTaskTrigger -Daily -At '12:00'
        $settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
        Register-ScheduledTask -TaskName 'dotopencode-sync' -Action $action -Trigger $trigger -Settings $settings `
            -Description 'git pull ~/.opencode and relink skills, crews, rules and MCP for Claude Code + OpenCode' -Force | Out-Null
        Write-Host "  'dotopencode-sync' runs daily at 12:00 (or at next sign-in if missed). Log: $LogDir\last-run.log"
    } catch {
        Write-Warning "  Couldn't register the task: $($_.Exception.Message)"
    }
}

# ---------- summary ----------

if ($script:dupes.Count) {
    Write-Host "`nDuplicate skill names ($($script:dupes.Count)); first one wins:"
    $script:dupes | Select-Object -First 25 | ForEach-Object { Write-Host "  $_" }
    if ($script:dupes.Count -gt 25) { Write-Host "  ...and $($script:dupes.Count - 25) more (see $LogDir\last-run.log)" }
}
if ($script:conflicts.Count) {
    Write-Host "`nLeft alone ($($script:conflicts.Count)):"
    $script:conflicts | ForEach-Object { Write-Host "  $_" }
}
Write-Host "`nDone. Restart Claude Code and OpenCode to load the changes."
if ($DryRun) { Write-Host 'This was a dry run: nothing was changed.' }
try { Stop-Transcript | Out-Null } catch { }
