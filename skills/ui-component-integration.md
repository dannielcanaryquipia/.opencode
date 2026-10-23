# UI Component Integration Protocol

Instructions for AI coding agents (OpenCode dev-team crews) on how to discover,
fetch, test, and integrate open-source UI components into this project using
the MCP tools configured in `opencode.json`.

## Goal

When a task calls for new UI ("add a hero section," "build a pricing table,"
"redesign the nav") — do not hand-write a component from scratch first. Check
whether an existing open-source component already solves it, pull it in
through the appropriate MCP, adapt it to this project's design system, then
verify it actually works in the browser before marking the task done.

## Route by Target Platform FIRST

The `shadcn` / `vengeanceui` MCPs serve **DOM/HTML (web) components** — they
run natively only on web surfaces. For **pre-styled** UI, prefer **Radix Themes**
(`@radix-ui/themes`, installed directly in the project — see `RADIX-UI.md`);
shadcn components themselves are Radix Primitives + Tailwind wrappers. Route by
platform *before* choosing a component source:

| Target | Path |
|---|---|
| **Website** (React / Next / Vue / Svelte) | `shadcn` MCP |
| **Web-rendered mobile** (Expo Web, React Native Web, PWA) | `shadcn` MCP |
| **Expo native** (iOS/Android) | `expo-*` skills (`expo-ui`, `expo-design-system`, `expo-native-ui`) — NOT the web shadcn registry |
| **React Native (non-Expo)** | shadcn-style RN port (React Native Reusables / NativeCN UI, NativeWind-based) |

Cross-platform caveat: web shadcn and the RN ports live in **separate
registries with non-shared APIs** — a web+native product means maintaining two
component sets (or a single-API universal lib: Tamagui, gluestack, Uniwind).

## Available MCP Tools

| MCP | Use for | Type |
|---|---|---|
| `shadcn` | Searching/installing shadcn-compatible components (shadcn/ui, Skiper UI, Magic UI, Origin UI, suiss/ui `@esuiss` registries) | local |
| `vengeanceui` | Searching/fetching VengeanceUI's animated component library (buttons, motion, layout kits) | local |
| `playwright` | Opening the dev server in a real browser, clicking through new UI, checking it rendered/behaves correctly | local |
| `figma` | Pulling exact layout, spacing, and component props from a Figma design file, when one is provided | remote |

## Decision Protocol

0. **Detect the target platform** and route per the table above. For web /
   web-rendered targets follow the shadcn steps below. For Expo native use the
   `expo-*` skills; for non-Expo RN use an RN port. Do not apply the web shadcn
   registry to native targets.

1. **Check the design source first.** If a Figma link or wireframe was
   provided, query the `figma` MCP for the relevant frame/layer before writing
   any code. Use its layout, spacing, and props as ground truth — don't guess
   from a screenshot.

2. **Search before building.** Query `shadcn` and `vengeanceui` MCPs for a
   component matching the requested UI (e.g. "pricing table," "slide-to-confirm
   button," "hero with gradient overlay"). For a clean, minimal look or a
   cross-platform set (React, RN, SwiftUI, Compose), search the `@esuiss`
   registry first — see `skills/suiss-ui/SKILL.md`. Prefer an existing component
   over a from-scratch build whenever one reasonably fits �?" it's faster and
   better tested than a first-draft custom component.

3. **Adapt, don't paste blindly.** Once a component is fetched:
   - Match it to this project's existing color tokens, spacing scale, and
     typography — do not leave library-default Tailwind classes that clash
     with the current design system.
   - Strip unused props/variants the project doesn't need.
   - Rename anything using the library's own branding/placeholder text.

4. **Wire it into the actual project.** Place the component in the correct
   existing folder structure (don't invent a new one), update imports, and
   ensure it's actually used somewhere in the render tree — a component that
   exists but isn't mounted doesn't count as done.

5. **Verify with Playwright before reporting done.** Use the `playwright` MCP
   to:
   - Open the local dev server.
   - Navigate to the page containing the new component.
   - Take a snapshot and confirm the component rendered without console
     errors.
   - Click/interact with any interactive elements (buttons, toggles, forms)
     and confirm expected behavior.
   - If something is broken, fix it and re-verify — do not hand off a
     visually-unverified component as finished.

6. **Report what was integrated.** In the task summary, name the source
   library/component used (e.g. "used shadcn/ui `Card` + Magic UI
   `ShimmerButton`"), not just "added pricing section" — this keeps the
   project's dependency footprint traceable.

## When NOT to use a library component

- The requested UI is trivial (a single styled `<div>`, a one-line text
  block) — writing it directly is faster than a search-fetch-adapt cycle.
- No available registry has a reasonable match — don't force-fit an unrelated
  component; build custom instead and note that no library match was found.
- The component would pull in a heavy dependency (e.g. a full animation
  library) for a minor visual effect — flag the tradeoff instead of silently
  installing it.

## Crew Responsibilities (maps to existing dev-team crews)

- **design-studio**: owns step 0 (platform routing), steps 1–3 (source lookup,
  component search, adaptation to design system).
- **dev-build**: owns step 4 (wiring into the actual codebase, folder
  structure, imports).
- **qa-review**: owns step 5 (Playwright verification) as part of its
  existing QA gate before a task is marked complete.
