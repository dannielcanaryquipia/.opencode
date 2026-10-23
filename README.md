# .opencode — Personal Agent Workspace

A self-contained agent-development workspace: 112 skill collections, a 5-crew dev
team, website/motion design system, manifest-first site templates, and a live
graphify knowledge graph covering the **entire directory**.

## What this is

This is the home directory for your AI tooling setup. It combines:

- **Skills** (`skills/`) — 112 top-level collections (353 skills total) spanning
  coding, design, game development, UI/UX, media, and productivity.
- **Dev team agents** (`agent/`) — 5 crews implemented as opencode subagents with
  a defined work-splitting protocol.
- **Design-first UI system** — a gated design phase (`skills/design-phase/`) that
  locks screens, tokens, component choices and static previews before feature
  code; suiss/ui registry integration (`skills/suiss-ui/`); canonical
  animation/motion tokens (`DESIGN.md`); Radix UI guidance (`RADIX-UI.md`);
  open-source Apple-style template index (`OPEN-SOURCE-TEMPLATES.md`).
- **Templates** (`templates/`) — requirements-driven site builds with a typed
  manifest and asset-checking pipeline.
- **Knowledge graph** (`graphify-out/`) — a graph of this whole directory, so
  agents can answer questions about it without mass-grepping source files.

## Directory layout

| Path | Contents |
|---|---|
| `agent/` | Dev-team subagent definitions (5 crews). See `TEAM-GUIDE.md`. |
| `skills/` | Skill collections — see "Skills" below. |
| `skills-upload/` | Shareable per-skill zips + `INDEX.md` catalog + `normalize_skills.py` fixer. Source for re-installing a single skill. |
| `phosphor-icons/` | Local Phosphor icon set (MIT): 1,512 icons × 6 weights as SVG, flat SVG and PNG, plus web fonts. No code — drop into `public/` and color via `currentColor`. |
| `templates/` | `site-requirements/` scaffold (typed manifest, asset manifest, motion spec, phase plan) and `design-phase/` (screen map, component inventory, sign-off). |
| `graphify-out/` | Knowledge graph: `graph.json`, `graph.html`, `GRAPH_REPORT.md`, `PROJECT-MAP.md`, community labels, caches. |
| `.claude/` | Claude Code settings (`settings.json`). |
| `.opencode/` | opencode plugin config (plugins, `node_modules`, package files). |
| `node_modules/` | JS deps from `package.json` (gitignored). |
| `.gitignore` | Ignores `node_modules` + package-lock/package files. |
| Top-level `.md` files | Documentation map — see below. |
| `opencode.json` | opencode config: shadcn MCP + graphify MCP servers. |

## Documentation map

| File | Covers |
|---|---|
| `AGENTS.md` | Agent rules: graphify usage, UI/motion/Radix workflow, ADHD mode, manifest-first site builds. |
| `CLAUDE.md` | Claude Code equivalent of `AGENTS.md` (graphify + rules). |
| `SKILLS-GUIDE.md` | Master mapping of skills, components, and patterns per project type. |
| `TEAM-GUIDE.md` | The dev team roster, per-crew skill inventory, and work-splitting protocol. |
| `DESIGN.md` | Canonical design/animation tokens (easing, durations) the `web-animation` skill reads. |
| `RADIX-UI.md` | Radix Themes & Primitives skill — when/how to choose components. |
| `WEB-ANIMATION.md` | The `web-animation` skill — what it covers and how to use it. |
| `OPEN-SOURCE-TEMPLATES.md` | Curated open-source Apple-style interactive sites (Three.js + GSAP) to clone/remix. |
| `UI-COMPONENT-MCP.md` | On-demand MCP servers (playwright, etc.) for pulling in and browser-testing UI components. |
| `skills/design-phase/SKILL.md` | Design-first gate — screen map, tokens, `@esuiss` inventory, static screens, sign-off. |
| `skills/suiss-ui/SKILL.md` | suiss/ui `@esuiss` registry — catalog, install, platform routing, guardrails. |
| `skills/website-compliance-checklist/CHECKLIST.md` | The 20-item pre-launch legal/compliance checklist (privacy, cookies/consent, dark patterns, accessibility, licenses, …). Not legal advice. |

## Dev team agents (`agent/`)

| Crew | File | Dispatch for |
|---|---|---|
| Dev/Build | `dev-build.md` | Scaffolding, features, refactors, bugfixes |
| Design Studio | `design-studio.md` | Landing pages, portfolios, redesigns, UI polish |
| Game Dev | `game-dev.md` | Game projects, engine work, shaders, multiplayer, assets |
| Ops/Planning | `ops-planning.md` | Project kickoff, planning, work-splitting, runbooks |
| QA/Review | `qa-review.md` | Review gates, bug hunts (read-only, never edits) |

## Skills (`skills/`)

112 top-level collections. Main clusters:

- **Coding & engineering** — `Claude-Cortex` (patterns, security, infra, perf,
  docs, review), superpowers-* (planning, TDD, verification), ponytail-*,
  caveman-*, systematic-debugging, karpathy-guidelines, test-driven-development.
- **Web / design / motion** — design-taste-frontend, frontend-design/dev,
  ui-ux-pro-max, ui-ux-design-pro, high-end-visual-design, brand/brandkit,
  banner-design, image-to-code, imagegen-* (web + mobile), gpt-taste, minimalist-ui,
  brutalist-ui, industrial-brutalist-ui, radix-ui, suiss-ui, design-phase,
  web-animation, gsap-core, emilkowalski-motion, impeccable-design-polish,
  ui-styling, slides, dashboard-designer,
  **threeui-integration** (ThreeUI Community WebGL/Three.js/shader components).
- **Game development** — game-development-* (orchestrator + 10 platform skills),
  unity-* (develop, ecs-patterns, ai-game-creator), unreal-engine-cpp-pro,
  godot-* (13 skills), game-art/audio/design.
- **Mobile** — `expo-skills` (router, native-ui, animation, EAS, design system,
  and more), expo-overview.
- **Media & audio** — audio-to-midi, midi-synth, seedance, 2d-pixel-asset,
  gemini-image-gen, google-ai-studio-tts, video-download / video-summarizer.
- **Review & compliance** — multi-specialist-review, codex-code-review, test-review,
  accessibility-audit, compliance-audit, html-seo-review, playwright / webapp-testing,
  **website-compliance-checklist** (20-item pre-launch legal + accessibility audit).
- **Agent/productivity** — i-have-adhd, clarity, skill-creator, writing-*,
  grilling, grilling-with-docs, graphify-setup, opencode, research, backlog-md,
  **find-skills** (discover + install more skills from the open ecosystem via
  `npx skills find`).

## Templates (`templates/`)

**`site-requirements/`** — requirements-driven build contract:

- `site.config.ts` — typed manifest (assets, copy, sections).
- `ASSET-MANIFEST.md` — required asset inventory; unresolved slots render as
  labeled `PlaceholderSlot`s.
- `MOTION-SPEC.md` — motion/animation spec to plan from.
- `PLAN.md` — the full Phase 1–5 build process, with a design gate in Phase 2.

**`design-phase/`** — the UI contract that must be approved before feature code:

- `SCREEN-MAP.md` — every route, state and breakpoint.
- `COMPONENT-INVENTORY.md` — every element mapped to `@esuiss` or custom.
- `DESIGN-APPROVAL.md` — evidence checklist, named sign-off and frozen files.

## Knowledge graph (`graphify-out/`)

Snapshot of the entire directory as of **2026-10-23**:

- **31,435 nodes · 38,328 edges · 2,375 communities**
- `graph.json` — the graph itself; `graph.html` — interactive aggregated view
  (community-level; pass `--obsidian` for full node-level detail).
- `GRAPH_REPORT.md` — broad architecture review; `PROJECT-MAP.md` — token-cheap
  orientation.
- `wiki/index.md` (when present) — navigation for broad sweeps.
- `manifest.json` — per-file extraction manifest.

> These counts move every time the graph rebuilds. Treat them as a dated snapshot,
> not a target — and expect the exact numbers to differ after your own
> `graphify update .`.

Usage:

```
graphify query "..."      # scoped subgraph for a question
graphify path "A" "B"     # relationships between two things
graphify explain "X"      # plain-language node + neighbors
graphify update .         # re-extract code / keep graph current (AST-only, free)
```

## Config & dependencies

- `opencode.json` — registers the `shadcn` and `graphify` local MCP servers.
- `package.json` — `@opencode-ai/plugin`, `@radix-ui/themes`, `framer-motion`,
  `shadcn` (dev).
- `node_modules/`, `package.json`, `package-lock.json` are gitignored.

## Contributing & conventions

- After modifying code, run `graphify update .` to keep the graph current.
- New UI work loads `skills/design-phase/SKILL.md` and passes `DESIGN-APPROVAL.md` before feature code.
- Keep new docs linked from this README and `SKILLS-GUIDE.md` where relevant.
- Wire any new agent crew updates into `TEAM-GUIDE.md`.
- New skill = `skills/<name>/SKILL.md` with `name` + `description` frontmatter, plus
  a shareable `skills-upload/<name>.zip` and an `INDEX.md` row. If `graphify update`
  warns that community labels drifted (hub renames), run `graphify label` to refresh
  names with the LLM.
- Any public or client-facing site ships only after `qa-review` clears the
  `website-compliance-checklist` gate (protocol step 8b in `TEAM-GUIDE.md`).

## Git

Initialized on `main` (initial commit: "Add graphify knowledge graph + skills").
Push with:

```
git remote add origin <your-repo-url>
git push -u origin main
```