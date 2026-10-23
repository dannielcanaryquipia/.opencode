# UI Component MCP — On-Demand Toggle & Integration Guide

This project can pull in **free open-source UI components** and **test them in a
real browser** through four MCP servers. They are wired into opencode's global
config (`~/.config/opencode/opencode.jsonc`) but are **not always running** — see
the lifecycle rules below so they only start when you need them.

For a new build, run `skills/design-phase/SKILL.md` first: components are chosen
in `COMPONENT-INVENTORY.md` and frozen in `DESIGN-APPROVAL.md` before any
integration.

## The four MCP servers

| Server | What it does | Default | How it runs |
|---|---|---|---|
| `playwright` | Opens your app in a real browser, clicks through new UI, verifies it renders & behaves, no console errors | **enabled** | local `npx @playwright/mcp@latest` |
| `shadcn` | Browse/search/install shadcn-compatible components (shadcn/ui, Skiper UI, Magic UI, Origin UI, suiss/ui registries) | disabled | local `npx shadcn@latest mcp` |
| `vengeanceui` | Browse/search VengeanceUI's animated component library (buttons, motion, layout kits) | disabled | local `node ...\.mcp-servers\vengeanceui-mcp\dist\server.js` |
| `figma` | Pull exact layout, spacing, and props from a Figma file when one is provided | disabled | remote `https://mcp.figma.com/mcp` (OAuth) |

## When is the server actually running?

- Nothing auto-runs at **boot or shutdown**. These are stdio child processes
  spawned by opencode, not Windows services or startup tasks. They die when
  opencode exits. Opening your laptop never starts them.
- `playwright` spins up when an opencode session starts (it's enabled by
  default so QA can verify UI in any project).
- `shadcn`, `vengeanceui`, and `figma` start **only when you enable them** for a
  component-integration task, and stop when you disable them or close opencode.

## Enabling / disabling on demand

Enable the ones you need before integrating a component:

```bash
opencode mcp enable shadcn
opencode mcp enable vengeanceui
opencode mcp enable figma      # only if a Figma design file is involved
```

Confirm what's up:

```bash
opencode mcp list
```

Turn them back off when the integration is done:

```bash
opencode mcp disable shadcn
opencode mcp disable vengeanceui
opencode mcp disable figma
```

> If your opencode version doesn't reload MCPs live, quit and restart opencode
> after toggling. Config is read at startup.

## Where Radix fits in this stack

Two of the four component sources are **Radix** under the hood:

- **`shadcn` MCP** — fetches shadcn/ui components, which are Radix Primitives + Tailwind wrappers.
- **`vengeanceui` MCP** — animated components; many build on Radix primitives too.

The **pre-styled** Radix layer (`@radix-ui/themes`) is not a registry component — you
install it directly in the project (`npm install @radix-ui/themes`, import
`styles.css`, wrap in `<Theme>`). Decide which path first:

| I want… | Use |
|---|---|
| Pre-styled theme + components immediately | Radix Themes (install directly — see `RADIX-UI.md`) |
| Radix accessibility + my own Tailwind look | `shadcn` MCP |
| Single headless primitive not wrapped by shadcn | Radix Primitives `@radix-ui/react-*` |

Decision protocol + detail: `skills/radix-ui/SKILL.md`.

## Web vs Mobile: which path

**shadcn UI components are DOM/HTML-based (React + Radix UI) — they run natively
only on the web.** Route by target platform *before* choosing a component source:

| Target | Path | Notes |
|---|---|---|
| **Website** (React / Next / Vue / Svelte) | `shadcn` MCP | First-class, works directly |
| **Web-rendered mobile** (Expo Web, React Native Web, PWA) | `shadcn` MCP | Renders through the DOM, so shadcn works |
| **Expo native** (iOS/Android) | `expo-ui` / `expo-design-system` / `expo-native-ui` skills | Do NOT use the web shadcn registry |
| **React Native (non-Expo)** | shadcn-style **port**: React Native Reusables or NativeCN UI (NativeWind-based) | Separate registry + API from web shadcn |

**Cross-platform caveat:** the web shadcn registry and the RN ports (React Native
Reusables / NativeCN / gluestack) live in **separate registries with different,
non-shared APIs**. A product shipping both web and native means you maintain two
component sets and hand-sync them — unless you use a single-API "universal"
library (Tamagui, gluestack, Uniwind) that targets both from one codebase.

## Typical integration flow (search before you build)

0. **Detect the target platform** and route (see "Web vs Mobile: which path"
   above) — web → shadcn, Expo native → expo-* skills, non-Expo RN → RN port.
   Only proceed to the shadcn steps below for web / web-rendered targets.
1. **Enable** the servers you need (above), then restart opencode if prompted.
2. **Design source first** — if a Figma link/wireframe was provided, query the
   `figma` MCP for layout, spacing, and props as ground truth.
3. **Search, don't hand-write** — query `shadcn` and `vengeanceui` for a matching
   component (e.g. "pricing table", "slide-to-confirm button", "hero with
   gradient overlay"). Prefer an existing component over a from-scratch build.
4. **Adapt** — match the fetched component to this project's color tokens,
   spacing scale, and typography. Strip unused props/variants and any library
   branding/placeholder text.
5. **Wire it in** — place it in the existing folder structure, update imports,
   and make sure it's actually mounted in the render tree.
6. **Verify with Playwright** — open the dev server, navigate to the page, take a
   snapshot, confirm no console errors, and interact with any interactive
   elements. Fix anything broken and re-verify.
7. **Report the source** — name the library/component used (e.g. "shadcn/ui
   `Card` + Magic UI `ShimmerButton`") so the dependency footprint stays traceable.
8. **Disable** the servers again when done.

## When NOT to use a library component

- The UI is trivial (a single styled `<div>`, a one-line text block) — write it directly.
- No registry has a reasonable match — build custom and note no library match was found.
- The component pulls a heavy dependency for a minor effect — flag the tradeoff
  instead of silently installing it.

## Per-project registry setup (shadcn)

The `shadcn` server browses registries configured in a project's
`components.json`. The standard shadcn/ui registry works with no config; to add
extra registries (Skiper UI, Magic UI, Origin UI), put them in that file:

```json
{
  "registries": {
    "@skiper": "https://skiperui.com/r/{name}.json",
    "@magicui": "https://magicui.design/r/{name}.json",
    "@originui": "https://originui.com/r/{name}.json",
    "@esuiss": "https://suiss.app/ui/r/{style}/{name}.json"
  }
}
```

`@esuiss` is suiss/ui — a 232-item shadcn-spec registry (components, blocks,
charts, patterns, interactions) for React, React Native, SwiftUI and Jetpack
Compose. The `{style}` placeholder is resolved from `components.json`, so
`radix-nova` fetches the radix base in the nova style; RN and native styles use
the platform-specific names (`rn-uniwind-suiss`, `rn-nativewind-suiss`,
`rn-stylesheet-suiss`, `swift-suiss`, `kotlin-suiss`). Full protocol:
`skills/suiss-ui/SKILL.md`.

## Crew ownership

- **design-studio** — step 0 platform routing, steps 2–4: design-source lookup, component search, adaptation.
- **dev-build** — step 6: wiring into the codebase, folder structure, imports.
- **qa-review** — step 7: Playwright browser verification as part of its QA gate.

## Files & locations

- Global MCP config: `~/.config/opencode/opencode.jsonc`
- Integration protocol: `skills/ui-component-integration.md`
- Built VengeanceUI server: `C:\Users\Danniel Canary\.mcp-servers\vengeanceui-mcp\dist\server.js`
- This guide: `UI-COMPONENT-MCP.md`
