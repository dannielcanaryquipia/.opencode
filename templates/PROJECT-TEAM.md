# Project Team Guide

This project runs with a dev team. Read `.opencode/TEAM-GUIDE.md` before starting any work — it defines the 5 crews (subagents), their skill inventories, and the work-splitting protocol.

## Your team
- **Developers** — `dev-build`: features, refactors, bugfixes
- **Design Studio** — `design-studio`: UI, visual direction, redesigns
- **Game Dev** — `game-dev`: Unity/Unreal/Godot/web games
- **QA/Review** — `qa-review`: review gates and completion verification (read-only)
- **Ops/Planning** — `ops-planning`: specs, plans, work splitting, coordination

## How to work here
1. **Read first** — this file, `.opencode/TEAM-GUIDE.md`, then the repo's CLAUDE.md/AGENTS.md and existing structure
2. **Plan before code** — ops-planning/brainstorming for anything non-trivial; write specs to `docs/superpowers/specs/`
3. **Design gate** — for UI work, `design-studio` runs `design-phase`; no feature code until `DESIGN-APPROVAL.md` is signed
4. **Split work by crew** — dispatch via Task tool; parallel when independent
5. **Never skip the gate** — `qa-review` before claiming completion
6. **Evidence** — lint/typecheck/build/tests with real output, always

## Project context
<!-- Fill these in at project setup: -->
- **Purpose:** (what this project is)
- **Stack:** (framework, backend, styling)
- **Conventions:** (naming, patterns, commands from CLAUDE.md)
- **Deployment:** (where it ships)
