# Dev Team Guide

Your project has a **dev team** — 5 crews implemented as subagents. Whenever you take on work in this project, read this file: it defines the team, the full skill inventory per crew, and the work-splitting protocol. The `skills/` folder currently holds **112 collections / 353 skills**; the inventories below are the authoritative map of which crew commands what.

## Roster

| Crew | Agent | Skill inventory (summary) | Dispatch when... |
|---|---|---|---|
| **Developers** | `dev-build` | superpowers-* (core), ponytail-* (6), caveman-* (6), systematic-debugging, TDD, karpathy-guidelines, full-output-enforcement, claude-skills/opencode, + ~45 Claude-Cortex engineering skills (patterns, security, infra, perf) | Scaffolding, features, refactors, bugfixes, any code |
| **Design Studio** | `design-studio` | design-taste-frontend, frontend-design/dev, ui-ux-pro-max, ui-ux-design-pro, minimalist/brutalist, brandkit, brand, banner-design, design, design-system, slides, ui-styling, dashboard-designer, checklist-design, imagegen-* (2), image-to-code, gpt-taste, stitch, high-end-visual-design, redesign, design-phase, suiss-ui, web-animation, gsap-core, emilkowalski-motion, impeccable-polish, + ~20 Claude-Cortex design/UX skills, gemini-image-gen, 2d-pixel-asset, tech-product-landing, threeui-integration | Landing pages, portfolios, redesigns, UI polish, visual direction |
| **Game Dev** | `game-dev` | game-development, game-developer, game-development-* (10), unity-* (3), unreal-engine-cpp-pro + claude-skills/unreal-* (5), godot-* (13), + media/asset pipeline (2d-pixel-asset, audio-to-midi, midi-synth, seedance) | Game projects, engine work, shaders, physics, multiplayer, game assets |
| **QA/Review** | `qa-review` | requesting/receiving code review, verification-before-completion, superpowers verification, caveman-review, ponytail-review, caveman-commit, TDD, + ~20 Claude-Cortex review/audit skills (multi-specialist-review, testing-*, doc-*, accessibility, ux-review, security, playwright/webapp-testing), website-compliance-checklist | Review gates, bug hunts, "is it done?" — read-only, never edits |
| **Ops/Planning** | `ops-planning` | brainstorming, writing-plans, executing-plans, superpowers-* (planning), dispatching-parallel-agents, subagent-driven-development, git-worktrees, finish-branch, writing-skills, caveman-compress, graphify-setup, + ~30 Claude-Cortex planning/PM/doc skills | Kickoff, specs, plans, work splitting, coordination, docs, research |

## Full skill inventory per crew

### Developers — `dev-build`
**Core discipline:** `test-driven-development`, `systematic-debugging`, `superpowers-tdd`, `superpowers-debugging`, `superpowers-receive-review`, `superpowers-request-review`, `superpowers-verification`, `superpowers-subagent`, `superpowers-parallel`, `karpathy-guidelines`, `output-skill` (full-output-enforcement), `ponytail` (+ audit/debt/gain/help/review), `caveman` (+ commit/compress/help/review/stats), `claude-skills/opencode` (cross-model delegation)

**Claude-Cortex engineering (45):** `api-design-patterns`, `api-gateway-patterns`, `async-python-patterns`, `backlog-md`, `atomic-commits`, `build-optimization`, `codanna-codebase-intelligence`, `condition-based-waiting`, `cqrs-event-sourcing`, `database-design-patterns`, `defense-in-depth`, `dev-workflows`, `dispatching-parallel-agents`, `event-driven-architecture`, `feature-implementation`, `github-actions-workflows`, `git-ops`, `gitops-workflows`, `helm-chart-patterns`, `implementation-workflow`, `incident-response`, `kubernetes-deployment-patterns`, `kubernetes-security-policies`, `legacy-modernization`, `microservices-patterns`, `openapi-specification`, `owasp-top-10`, `python-performance-optimization`, `python-testing-patterns`, `react-performance-optimization`, `reasoning-controls`, `release-prep`, `repo-cleanup`, `root-cause-tracing`, `secure-coding-practices`, `security-testing-patterns`, `system-design`, `terraform-best-practices`, `testing-anti-patterns`, `test-generation`, `test-review`, `threat-modeling-techniques`, `tool-selection`, `typescript-advanced-patterns`, `vibe-security`, `wiring-audit`

### Design Studio — `design-studio`
**Core direction:** `design-taste-frontend` (+`v1`), `frontend-design`, `frontend-dev`, `ui-ux-pro-max`, `ui-ux-design-pro-skill`, `minimalist-ui`, `industrial-brutalist-ui`, `gpt-taste`, `stitch-design-taste`, `high-end-visual-design` (soft-skill), `taste-skill` (+`v1`)

**Design gate:** `design-phase` owns D0–D7 before feature code — screen map, tokens, `@esuiss` component inventory, component lab, static screens at 390/768/1440, motion spec and a named `DESIGN-APPROVAL.md` sign-off. `suiss-ui` supplies the registry path; do not invent components that the inventory has not approved.

**Brand & identity:** `brandkit`, `brand`, `banner-design`, `design`, `design-system`, `slides`, `ui-styling`, `brand-library-architect`

**Products & dashboards:** `dashboard-designer-skill`, `checklist-design`, `chart-builder`

**Image & code-to-visual:** `imagegen-frontend-web`, `imagegen-frontend-mobile`, `image-to-code` (+`-skill`), `gemini-image-gen`, `2d-pixel-asset`, `tech-product-landing`, `seedance` (video/trailers), `threeui-integration` (ThreeUI Community WebGL/Three.js/shader components — the WebGL sibling of the `ui-component-integration` protocol below; owns its own analyze → brief → catalog-select → live-preview → plan → install → integrate → browser-verify loop and must hand the browser verification to `qa-review`)

**Motion & polish:** `web-animation`, `gsap-core`, `emilkowalski-motion`, `impeccable-design-polish`, `redesign-existing-projects`

**UI component integration** (`skills/ui-component-integration.md`): search-before-build protocol using the `shadcn` (including the `@esuiss` suiss/ui registry), `vengeanceui`, `playwright` (test), and `figma` (design source) MCPs — globally configured in `~/.config/opencode/opencode.jsonc`. Only `playwright` is enabled by default; `shadcn`, `vengeanceui`, and `figma` are **disabled on-demand** — run `opencode mcp enable <name>` before a UI-integration task (and `opencode mcp disable <name>` after). Owns step 0 (platform routing) and steps 1–3 (design-source lookup, component search, adaptation to design tokens); routes by target — web → shadcn MCP, Expo native → `expo-*` skills, non-Expo RN → RN shadcn ports; hands off wiring to `dev-build` and Playwright verification to `qa-review`. See `UI-COMPONENT-MCP.md`.

**Claude-Cortex design/UX (~20):** `canvas-design`, `color-palette`, `design-critiquer`, `design-journey-review`, `design-system-architecture`, `interaction-design`, `super-saiyan`, `ui-design-aesthetics`, `ui-ux-review-suite`, `user-journey-mapping`, `ux-interaction-review`, `ux-researcher`, `ux-review`, `ux-writer`, `visual-modes`, `accessibility-audit`

### Game Dev — `game-dev`
**Orchestration:** `game-development`, `game-developer`

**Platforms (10):** `game-development-2d-games`, `-3d-games`, `-game-art`, `-game-audio`, `-game-design`, `-mobile-games`, `-multiplayer`, `-pc-games`, `-vr-ar`, `-web-games`

**Unity (3):** `unity-ai-game-creator`, `unity-developer`, `unity-ecs-patterns`

**Unreal (6):** `unreal-engine-cpp-pro`, `unreal-best-practices`, `unreal-blueprint-codegen`, `unreal-gas`, `unreal-pcg-python`, `unreal-thirdparty`

**Godot (13):** `godot-4-migration`, `godot-clear-children`, `godot-console`, `godot-gdscript-grammar`, `godot-gdscript-patterns`, `godot-global-variables`, `godot-knowledge`, `godot-packedscene`, `godot-scene`, `godot-serialization-pattern`, `godot-singleton-pattern`, `godot-tscn-format`, `godot-unix-timestamp-fix`

**Asset & media pipeline:** `2d-pixel-asset`, `audio-to-midi`, `midi-synth`, `seedance`

### QA/Review — `qa-review`
**Core gates:** `requesting-code-review`, `receiving-code-review`, `verification-before-completion`, `superpowers-request-review`, `superpowers-receive-review`, `superpowers-verification`, `caveman-review`, `ponytail-review`, `caveman-commit`, `test-driven-development`, `clarity` (prose draft/rewrite/review/lint — Addy Osmani). Owns step 5 of the UI-component protocol (`skills/ui-component-integration.md`): browser verification of any newly integrated component via the `playwright` MCP before marking done.

**Claude-Cortex review/audit (~20):** `codex-code-review`, `multi-specialist-review`, `quality-audit`, `testing-skills-with-subagents`, `test-generation`, `test-review`, `testing-anti-patterns`, `python-testing-patterns`, `accessibility-audit`, `ux-review`, `webapp-testing`, `playwright`, `html-seo-review`, `security-testing-patterns`, `owasp-top-10`, `compliance-audit`, `doc-claim-validator`, `doc-quality-review`, `doc-health-audit`, `wiring-audit`

**Pre-launch legal/compliance gate:** `website-compliance-checklist` — the 20-item audit (privacy, terms, refunds, cookies/consent, dark patterns, hidden fees, fake reviews, unsupported claims, accessibility, business details, unsubscribe, asset licenses, data deletion) in `skills/website-compliance-checklist/CHECKLIST.md`. Run it before delivering or launching any client/public site, and whenever forms, analytics, checkout, email capture or third-party scripts are added. Rules that matter for a read-only crew: it is **not legal advice and carries no guarantee** — report which items pass/fail and which need a lawyer; **never invent** company details, addresses, registration numbers, retention periods or processors (leave `{{PLACEHOLDER}}` and list them as "needs from owner"); **policies must be generated from what the code actually does**, not from a generic template; and **do not add fake trust signals** to make a failing item pass. Cross-links: audit items 13–15 (alt text, contrast, keyboard/`prefers-reduced-motion`) against any `threeui-integration` WebGL background `design-studio` shipped, and audit item 19 (asset licenses) against `phosphor-icons/` and the shadcn/MCP components pulled in via `UI-COMPONENT-MCP.md`.

### Ops/Planning — `ops-planning`
**Core workflow:** `brainstorming`, `writing-plans`, `executing-plans`, `superpowers-brainstorming`, `superpowers-executing-plans`, `superpowers-plans`, `superpowers-finish-branch`, `superpowers-git-worktrees`, `superpowers-parallel`, `superpowers-subagent`, `superpowers-skills`, `using-superpowers`, `subagent-driven-development`, `dispatching-parallel-agents`, `writing-plans`, `writing-skills`, `caveman-compress`, `graphify-setup`

**Planning & PM (~30 Claude-Cortex):** `task-orchestration`, `session-management`, `skill-creator`, `template-skill`, `template-skill-enhanced`, `sharing-skills`, `documentation-production`, `doc-architecture-review`, `doc-completeness-audit`, `doc-maintenance`, `reference-documentation`, `tutorial-design`, `development-estimation`, `decision-maker`, `requirements-discovery`, `product-manager`, `product-strategy`, `prd-generator`, `backlog-md`, `atlas-crew-tasks`, `justfile-author`, `research-methodology`, `web-researcher`, `knowledge-stack`, `knowledge-synthesis`, `multi-llm-consult`, `multi-perspective-analysis`, `constructive-dissent`, `evaluator-optimizer`, `mapping-suite`, `release-analysis`, `release-prep`, `internal-comms`

## Unstaffed crews (no agent file — do NOT pretend they exist; skills ARE installed)

| Crew | Agent file | Skills installed (cover the role, but no agent to drive them) | Status |
|---|---|---|---|
| Marketing | missing | `copywriter`, `blog-post`, `email-drafter`, `market-researcher`, `competitor-analyst`, `brand`, `banner-design`, `brand-library-architect`, `html-seo-review`, `slides`, `hermes-tweet` | skills installed, agent missing |
| Social & Content | missing | `storyteller`, `blog-post`, `copywriter`, `video-download`, `video-summarizer`, `video-fetch-and-summarize`, `google-ai-studio-tts`, `seedance`, `audio-to-midi`, `midi-synth`, `hermes-tweet`, `ai-tells-scan`, `ai-tells-review`, `proofreader` | skills installed, agent missing |
| Product (pre-planning) | missing | `prd-generator`, `product-manager`, `product-strategy`, `business-analyst`, `market-researcher`, `requirements-discovery`, `dataset-curator`, `eval-designer`, `model-comparator`, `prompt-engineering` | skills installed, agent missing |
| Finance | missing | `xlsx` (document-skills), `chart-builder`, `pdf`, `pptx` — no dcf/pricing/lbo skills | partial, mostly unstaffed |
| Operations (business) | missing | `internal-comms`, `incident-response`, `release-prep`, `xlsx`, `docx`, `pptx`, `pdf` — mostly covered by `ops-planning` | partial, mostly covered |
| Legal | missing | `terms-of-service`, `compliance-audit`, `docx`, `pdf` | partial, mostly unstaffed |

To staff a crew: create `agent/<crew>.md` (mirror the 5 existing agent files), then move its skills out of this table into the Roster.

## Work-splitting protocol (how the team works)

```
1. LOAD  ops-planning (or read its skills directly)
2. BRAINSTORM  → intent, constraints, success criteria
3. SPEC        → docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md
4. PLAN        → step-by-step implementation plan
5. SPLIT       → chunk work by crew:
     code/features         → dev-build
     UI/visual direction   → design-studio
     game/engine work      → game-dev
     completion claims     → qa-review (final gate)
     public/client site    → qa-review runs `website-compliance-checklist` before delivery
5b. DESIGN GATE → design-studio runs `design-phase`; no feature code until
                `DESIGN-APPROVAL.md` is signed
6. DISPATCH    → Task tool, parallel when chunks are independent
7. VERIFY      → lint/typecheck/build/tests with real output
8. GATE        → qa-review approves or requests changes
8b. COMPLY     → for any public or client-facing site, qa-review runs
                `website-compliance-checklist` and reports pass/fail/needs-a-lawyer.
                An item is only passed when it was observed working, not merely coded.
9. FINISH      → merge / PR / cleanup decision
```

## Rules for the coordinating agent
- **One crew per concern** — don't let a single agent do design + code + QA in one shot
- **QA is a gate, not a step** — never mark work complete without a `qa-review` pass
- **Skills before code** — crews must load their skills; improvising engine/design/planning without them is how hallucinations happen. Use the inventory above to pick the right skill; when in doubt, `graphify query` the skills graph (`graphify-out/`) for what covers a task
- **Design before code** — for any UI, `design-studio` completes `design-phase` and a signed `DESIGN-APPROVAL.md` before `dev-build` writes feature code
- **Read the repo first** — check CLAUDE.md / AGENTS.md / existing files before writing anything (avoids duplicate files)
- **Evidence over assertions** — every "done" claim must come with command output or a code reference

## Per-project setup
This `.opencode/` folder is the portable team unit. To staff a new project:
1. Copy this `.opencode/` folder into the project root
2. Copy `.opencode/templates/PROJECT-TEAM.md` to the project root (or reference it from AGENTS.md/CLAUDE.md)
3. Run `/graphify-setup` in the project root so the team can query the skills graph
4. Before UI work, load `design-phase` and get `DESIGN-APPROVAL.md` signed
5. The AI reads the guide on the first task and runs the protocol
