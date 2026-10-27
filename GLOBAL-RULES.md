# Danniel's global agent rules

These rules apply in every project, in both Claude Code and OpenCode. Source of truth: `~/.opencode/GLOBAL-RULES.md`, copied into `~/.claude/CLAUDE.md` and `~/.config/opencode/AGENTS.md` by `~/.opencode/sync-global.ps1`. A project's own CLAUDE.md / AGENTS.md wins where it disagrees.

## Skills

- My skill library lives in `~/.opencode/skills` and is linked into `~/.claude/skills`, so every skill is loadable by name with the skill tool. Guides and templates: `~/.opencode/SKILLS-GUIDE.md`, `~/.opencode/TEAM-GUIDE.md`, `~/.opencode/templates/`.
- Load a skill before the work it covers. Don't paraphrase a skill from memory.

## How gstack and my crews split the work

gstack owns the phase gates (framing, plan review, code review, QA, security, shipping). My crews and skills do the building. In OpenCode, gstack commands are prefixed: `/gstack-office-hours`, `/gstack-review`, and so on. If a command isn't found under one name, try the other.

| Phase | gstack | My crews / skills |
|---|---|---|
| 1. Frame | `/office-hours` for a new product or feature (writes the design doc) | `brainstorming` for smaller creative calls |
| 2. Plan | `/plan-eng-review`; UI work also `/plan-design-review`; big scope `/plan-ceo-review` or `/autoplan` | `writing-plans`; UI: `design-phase` first, no feature code before `DESIGN-APPROVAL.md` |
| 3. Build | — | dispatch `dev-build`, `design-studio`, `game-dev`; `test-driven-development`, `ponytail` |
| 4. Debug | `/investigate` | `systematic-debugging` |
| 5. Verify | — | `verification-before-completion`: evidence before any "done" |
| 6. QA gate | `/review` on the diff, `/qa` on a running web app, `/cso` when auth, payments, uploads or secrets change | `qa-review` crew runs the gstack commands and adds `ponytail-review`, `website-compliance-checklist` for public sites |
| 7. Ship | `/ship` (tests + PR), `/land-and-deploy` once set up, `/retro` weekly | `caveman-commit` for commit messages |

- Use `/review` as the default code review. Don't also run `requesting-code-review` on the same diff.
- For risky operations (migrations, deletes, prod config) use `/careful` or `/guard`.
- `ops-planning` crew owns planning docs and model choice (`model-role-picker`).

## Knowledge graph (graphify)

- If the project has `graphify-out/graph.json`: run `graphify query "<question>"` before grepping, `graphify path`/`graphify explain` for relationships, and `graphify update .` after code changes.
- If it doesn't and the project is more than a few files, offer `/graphify-setup` once.
- The `graphify` MCP server serves the graph of my skill library. Use it to find which skill fits a task.

## UI and websites

- Before building UI: `design-phase`, then `suiss-ui` (`@esuiss` registry via the shadcn MCP) or `radix-ui` before hand-writing components.
- Motion: `web-animation` + `gsap-core`, gated on reduced-motion.
- New client sites: start from `~/.opencode/templates/site-requirements/` (manifest-first). Never invent assets, copy or business facts; leave labeled placeholders.
- Verify finished UI in a real browser (`/qa`, `/browse` or the playwright MCP) before calling it done.

## Modes

- `/i-have-adhd` or "adhd mode": load `i-have-adhd` until "normal mode".
- `caveman` for terse output when asked; `ponytail` whenever a solution looks over-built.
