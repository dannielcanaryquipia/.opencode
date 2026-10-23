---
name: suiss-ui
description: Integrate suiss/ui components, blocks, patterns, charts and interactions into a project through its shadcn-compatible @esuiss registry. Use when the user says "use suiss", "suiss/ui", "add @esuiss", wants a clean minimal UI upgrade, needs copy-paste components or full page blocks, or wants a web or native interface to look more polished without hand-writing every component. Supports React, React Native, SwiftUI and Jetpack Compose.
---

# suiss/ui integration

suiss/ui is an MIT-licensed, shadcn-spec component registry with one design
system across React, React Native, SwiftUI and Jetpack Compose. Components are
copied into the project (vendored), not installed as a runtime dependency.

- Source: https://github.com/e-suiss/ui
- Docs: https://suiss.app/ui/docs
- Catalog: https://suiss.app/ui/r/registry.json

## What is in the registry

The base registry has 232 items:

| Type | Count | What it is |
|---|---|---|
| `registry:block` | 124 | Full sections and screens (heroes, stats, login, pricing, dashboards) |
| `registry:ui` | 69 | Primitives (button, dialog, select, table, tabs, input) |
| `registry:component` | 30 | Larger composed components |
| `registry:hook` | 6 | Behavior hooks |
| `registry:lib` | 2 | Shared utilities |
| `registry:theme` | 1 | The suiss theme (`theme-suiss`) |

Useful starting points: `hero-cinematic`, `hero-product`, `hero-tiles`,
`bento-stats`, `login-account`, `login-passkey`, `login-sheet`, `command-palette`,
`navbar`, `search-picker`, `paged-list`, `card-stack`, `image-viewer`,
`swipe-actions`, `pull-to-refresh`.

## Compatibility check (why this works)

- Each item validates against `https://ui.shadcn.com/schema/registry-item.json`
  and supports `dependencies` + `registryDependencies`.
- The shadcn CLI supports the `{style}` placeholder, and suiss serves
  `https://suiss.app/ui/r/{style}/{name}.json` — so the project's existing
  `style` picks the right base and theme.
- The `shadcn` MCP server reads `registries` from the project's
  `components.json`, so no separate suiss MCP is needed. suiss publishes no MCP
  endpoint and no REST API; the registry is static JSON.

## Setup

Requirements: Node 20+, Tailwind CSS 4.2+ for React, a `components.json`.

Add the namespace once per project:

```json
{
  "registries": {
    "@esuiss": "https://suiss.app/ui/r/{style}/{name}.json"
  }
}
```

Then enable the existing MCP and restart if needed:

```bash
opencode mcp enable shadcn
```

CLI equivalents:

```bash
npx shadcn@latest search @esuiss --query "hero"
npx shadcn@latest view @esuiss/hero-product
npx shadcn@latest add @esuiss/button @esuiss/dialog @esuiss/hero-product --dry-run
npx shadcn@latest add @esuiss/button @esuiss/dialog @esuiss/hero-product
```

What an install touches (verified with `--dry-run`):

- Writes to the project's configured aliases, e.g. `src/components/ui/button.tsx`
  and `src/lib/utils.ts` — not to a `bases/` folder.
- Installs `cn` (shadcn's clsx + tailwind-merge replacement),
  `class-variance-authority` and, for radix-base items, `radix-ui`.
- `@esuiss/theme-suiss` writes no component files: it adds ~71 CSS variables
  and `@fontsource-variable/inter`, and overwrites `lib/utils.ts`. Run
  `--diff` first; it is a global visual change.

Or use the suiss CLI for full project setup (writes theme, icons, folders):

```bash
npx @esuiss/ui@latest init
npx @esuiss/ui@latest add button dialog sheet
```

## Platform routing

Route before searching. Do not put DOM components on a native target.

| Target | Registry style | Notes |
|---|---|---|
| React / Next / Vite (web) | `{style}` resolves to `base-*`, `radix-*` or `aria-*` | Default base is Base UI; `radix-nova` etc. work if the project uses shadcn/Radix |
| Expo / React Native — Uniwind | `rn-uniwind-suiss` | Tailwind v4 |
| Expo / React Native — NativeWind v4 | `rn-nativewind-suiss` | Tailwind v3 |
| React Native — plain | `rn-stylesheet-suiss` | Uses `style` instead of `className` |
| SwiftUI (iOS 17+) | `swift-suiss` | Xcode project or Swift package |
| Jetpack Compose (minSdk 24+) | `kotlin-suiss` | No Material dependency |

Base names: `base-suiss` (default), `radix-suiss`, `aria-suiss`. Available
styles: `suiss`, `vega`, `nova`, `maia`, `lyra`, `mira`, `luma`, `sera`, `rhea`.
Rendered style is `<base>-<style>`, e.g. `radix-nova`.

For the suiss color tokens instead of the project's existing colors:

```bash
npx shadcn@latest add @esuiss/theme-suiss
```

Icons follow `iconLibrary` in `components.json` (Phosphor is the default).

## Workflow

If the project has no approved design, load `design-phase` first and finish the
screen map, component inventory and sign-off before wiring anything into the
app.

1. **Inspect the project.** Framework, Tailwind version, `components.json`,
   `iconLibrary`, existing design tokens, and the page that needs work. If
   `graphify-out/` exists, query it instead of grepping.
2. **Search, do not invent.** Ask the `shadcn` MCP for a match, or use
   `npx shadcn@latest search @esuiss --query "..."`. Prefer a block for page
   structure and a `registry:ui` item for single controls.
3. **View before adding.** `view @esuiss/<item>` shows files, dependencies and
   registry dependencies. Reject anything that drags in a heavy dependency for a
   small effect.
4. **Add.** Install through the MCP or CLI, after a `--dry-run`. Items land in
   the configured alias (e.g. `src/components/ui/`, `.../patterns/`,
   `.../interactions/`, `.../charts/`, `.../blocks/`) depending on type.
5. **Adapt.** Map colors, radius, spacing and typography to the project's
   tokens (see `DESIGN.md`). Remove unused variants, placeholder copy and
   library branding. Keep one style per project; do not mix shadcn defaults
   with suiss tokens unless the difference is deliberate.
6. **Wire it in.** Mount the component in the real render tree, matching the
   existing folder and import conventions. An unmounted component is not done.
7. **Add motion last.** See the handoff table below. Animate after the static
   layout and tokens are correct.
8. **Verify.** Open the dev server with the `playwright` MCP, check the page at
   390 / 768 / 1440 px, confirm no console errors, exercise interactive
   elements, and check focus states and contrast.
9. **Report** the exact registry items used (e.g. `@esuiss/hero-product` +
   `@esuiss/bento-stats`) so the dependency footprint stays traceable.

## Motion handoff

This skill supplies structure and styling; it does not define a new motion
system. Use the existing skills:

| Need | Load |
|---|---|
| Entrance, scroll reveal, stagger, page transition, micro-interactions (React web) | `web-animation` |
| Taste pass on an existing interface (restraint, timing, state transitions) | `emilkowalski-motion` |
| Timelines, ScrollTrigger pin/scrub, SVG morphing | `gsap-core` |
| Final audit, polish and animation review | `impeccable-design-polish` |
| Native motion (Reanimated, gestures, haptics) | `expo-animation` |

Rules: animate only `transform` and `opacity`; gate everything behind
`prefers-reduced-motion`; keep one hero-level motion moment per page and a
small number of micro-interactions; reuse the tokens in `DESIGN.md`.

## Guardrails

- Do not use web (`base-*` / `radix-*` / `aria-*`) items in Expo native — use
  the `rn-*` items or the `expo-*` skills.
- Do not promise an MCP connection to suiss; only the shadcn MCP + registry
  path exists.
- Do not silently overwrite vendored components. Review the diff first.
- Do not add a block when a single component does the job; blocks bring layout
  and copy you will have to strip.
- Keep the MIT attribution in the repo's dependency notes.
- If no item fits, build custom and say so rather than force-fitting.
