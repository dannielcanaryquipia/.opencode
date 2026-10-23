## graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.

When the user types `/graphify`, use the installed graphify skill or instructions before doing anything else.

Rules:
- For codebase questions, first run `graphify query "<question>"` when graphify-out/graph.json exists. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. These return a scoped subgraph, usually much smaller than GRAPH_REPORT.md or raw grep output.
- Dirty graphify-out/ files are expected after hooks or incremental updates; dirty graph files are not a reason to skip graphify. Only skip graphify if the task is about stale or incorrect graph output, or the user explicitly says not to use it.
- If graphify-out/wiki/index.md exists, use it for broad navigation instead of raw source browsing.
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context.
- After modifying code, run `graphify update .` to keep the graph current (AST-only, no API cost).

## UI, Motion & Radix (website work)

When the user wants to build or improve a **website, landing page, or app UI**:

- Use the **`radix-ui`** skill for pre-styled/component UI work (Radix Themes or the shadcn/MCP path — see `RADIX-UI.md`).
- Use **`suiss-ui`** (`skills/suiss-ui/SKILL.md`) for a fast premium UI upgrade or cross-platform components: 232 shadcn-spec items (components, blocks, charts, patterns) via the `@esuiss` registry, served through the same shadcn MCP - no new server.
- Use **`design-phase`** (`skills/design-phase/SKILL.md`) before any UI build: lock the screen map, tokens, `@esuiss` component inventory, static screens and sign-off (`templates/design-phase/`) before feature code.
- Use **`web-animation`** + **`gsap-core`** for motion; `DESIGN.md` holds the canonical tokens (scroll-driven Apple-style animation is allowed and preferred for product pages — scope every trigger, gate on reduced-motion).
- For **Apple-style interactive/3D pages** (Three.js + scroll storytelling), consult **`OPEN-SOURCE-TEMPLATES.md`** for open-source clones to copy from.
- Follow the search-fetch-verify protocol in `skills/ui-component-integration.md` before hand-writing components; verify finished UI with the playwright MCP.

## ADHD-friendly output (`i-have-adhd`)

When the user types `/i-have-adhd` or "adhd mode", load the **`i-have-adhd`** skill and follow its rules for the rest of the session. The skill reshapes output for ADHD readers: lead with next action, number steps, restate state, suppress tangents, give concrete time estimates, make wins visible. Turn off only on "stop adhd mode" or "normal mode". Full rules at `skills/i-have-adhd/skills/i-have-adhd/SKILL.md`.

## Requirements-driven site builds (manifest-first)

When starting a **new client/interactive website project**, use the requirements
template instead of guessing assets or copy:

- The blank contract lives in **`templates/site-requirements/`** (`site.config.ts`
  typed manifest + `ASSET-MANIFEST.md` + `MOTION-SPEC.md`). Reference project
  scaffold: `C:\Users\Danniel Canary\Desktop\site-interactive-sample` (its `docs/`
  is the canonical example).
- Workflow: scaffold → user fills `site.config.ts` + drops assets into
  `public/assets/` → `npm run assets:check` → plan from `MOTION-SPEC.md` → build →
  verify with playwright MCP.
- The AI never invents a file/image/model/headline: unfilled asset slots render
  as labeled `PlaceholderSlot`s and report via `resolveAsset()`/`unresolvedAssets()`.
- Full process is written up in `templates/site-requirements/PLAN.md` (Phase 1–5).
