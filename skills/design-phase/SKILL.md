---
name: design-phase
description: Run a design-first phase that locks the entire UI before application code is written. Use when starting a website or app, a redesign, or when the user wants to see and approve the full UI first — screen map, design tokens, component inventory, static screens, component lab and motion spec. Produces responsive screenshots and a sign-off gate so development starts from an approved design.
---

# Design phase (design before build)

The rule: **no application code until the design is signed off.** "Application
code" means routes, data fetching, state, auth, APIs and feature logic. Allowed
before sign-off: the scaffold, a throwaway component lab, static screens with
fixture data, and screenshots.

The developer should be able to see and click the entire UI — every screen,
state and breakpoint — before implementation starts.

## Inputs

Read what exists; fill only what is missing:

| Input | Where | Why |
|---|---|---|
| Product requirements | `needed-documents/PRD.md` | Scope, P0 features, non-goals |
| User journey | `needed-documents/APP-FLOW.md` | Screens, navigation, branches |
| Design brief | `needed-documents/DESIGN-BRIEF.md` | Audience, mood, palette, type |
| Technical requirements | `needed-documents/TRD.md` | Stack, constraints, NFRs |

If a doc is missing, write a one-page minimal version before continuing. Do not
invent brand facts, assets or copy; use labeled placeholders.

## Outputs

| Artifact | Path | Purpose |
|---|---|---|
| Screen map | `docs/design/SCREEN-MAP.md` | Every screen, route, state and breakpoint |
| Tokens | `docs/design/DESIGN-TOKENS.md` + CSS variables | Color, type, space, radius, elevation, motion |
| Component inventory | `docs/design/COMPONENT-INVENTORY.md` | Every element mapped to `@esuiss` or custom |
| Component lab | `/design` route or `docs/design/lab.html` | All components in all states, no app logic |
| Static screens | `/design/screens/*` or `docs/design/screens/` | Full layouts with fixture content |
| Motion spec | `templates/site-requirements/MOTION-SPEC.md` | Recipes, scroll behavior, reduced motion |
| Approval | `docs/design/DESIGN-APPROVAL.md` | Checklist + named sign-off + frozen files |

Templates: `templates/design-phase/SCREEN-MAP.md`,
`templates/design-phase/COMPONENT-INVENTORY.md` and
`templates/design-phase/DESIGN-APPROVAL.md`; motion contract:
`templates/site-requirements/MOTION-SPEC.md`.

## Phases

### D0 — Inputs (30–60 min)
Confirm audience, primary action per screen, P0 scope, non-goals, brand inputs,
device targets and accessibility bar. Stop if the primary action is unclear.

### D1 — Screen map
For each screen in `APP-FLOW.md`, record: route, purpose, primary action,
entry/exit, data shown, and **all states** — default, loading, empty, error,
success, disabled, hover/focus. Add breakpoints (390 / 768 / 1440) and what
changes at each. New screens are a scope decision, not an implementation detail.

### D2 — Tokens
Pick one direction and commit:

- Use a suiss style (e.g. `base-suiss`, `radix-nova`) and add
  `@esuiss/theme-suiss`, or define a custom token set.
- Define: color roles (surface, text, muted, border, primary, destructive),
  type scale, spacing scale (4/8px base), radii, elevation, focus ring, and
  motion tokens from `DESIGN.md`.
- Verify WCAG AA (4.5:1 body, 3:1 large text and UI boundaries) before approval.
- Never invent per-screen colors or fonts. One source of truth.

### D3 — Component inventory
Walk every screen and list every element in
`COMPONENT-INVENTORY.md`. Search `@esuiss` first (`shadcn` MCP or
`npx shadcn@latest search @esuiss --query "..."`), then decide:

- **Use** an `@esuiss` item as-is.
- **Adapt** an `@esuiss` item (record what changes).
- **Custom** — only when no item fits; record why and keep it minimal.

Build order: tokens -> primitives (`registry:ui`) -> patterns/interactions ->
blocks -> screens. Do not design screens from one-off components.

### D4 — Component lab + static screens
Build a component lab that renders every inventory item in every state, plus
static screens showing the full layouts with representative fixture content.
No API calls, no auth, no business logic. This is the artifact the developer
reviews.

- Every screen in the screen map exists at 390 / 768 / 1440.
- Every state is reachable (a query param or toggle is fine).
- Use real layout and real token values; placeholder copy and assets are
  labeled, never silently invented.
- For a marketing site, the static screen is the full scroll narrative; for an
  app, it is every route with seeded data.

### D5 — Motion spec
Fill `MOTION-SPEC.md`: per section, the recipe, trigger, scroll behavior, mood
and reduced-motion fallback. Motion is approved with the layout, not added
after build. Use `web-animation`, `gsap-core` and `emilkowalski-motion`.

### D6 — Review and sign-off
Run the `DESIGN-APPROVAL.md` checklist and capture a named approval with the
design version. Freeze the token file, component inventory and motion spec.
Changes after freeze go through a dated change-control entry.

### D7 — Build handoff
Development starts only after sign-off. Build in screen-map order, reuse the
inventory, and keep the lab alive as the drift check. After build, compare
Playwright screenshots at 390 / 768 / 1440 against the approved screens; any
unexplained difference is a regression.

## Gate (all must be true)

- [ ] Screen map covers every route and every state.
- [ ] Tokens are one source of truth and pass contrast checks.
- [ ] Every element is in the inventory with a source and status.
- [ ] Component lab renders all items in all states.
- [ ] Static screens render at 390 / 768 / 1440.
- [ ] Motion spec has reduced-motion fallbacks.
- [ ] `DESIGN-APPROVAL.md` is signed with a version.
- [ ] No feature code was written before this point.

## Tool routing

| Need | Use |
|---|---|
| Library/API behavior | `context7` MCP — verify, do not guess. suiss/ui is **not** indexed; verify it against `https://suiss.app/ui/r/registry.json`, npm (`@esuiss/ui`, MIT) and `shadcn view`/`--dry-run` |
| Components and blocks | `shadcn` MCP with `@esuiss`, plus `skills/suiss-ui/SKILL.md` |
| Visual direction | `design-taste-frontend`, `frontend-design`, `design-system`, `ui-ux-pro-max` |
| Screenshots and responsive checks | `playwright` MCP |
| Motion | `web-animation`, `gsap-core`, `emilkowalski-motion` |

## Anti-patterns

- Building features while "figuring out the design".
- Approving from memory or a single desktop screenshot.
- Skipping empty, loading and error states.
- Hand-writing a component that the registry already has.
- Mixing two design systems or two icon libraries.
- Adding motion before the static design is signed off.
- Treating "we'll fix it later" as approval.

## Definition of done

The developer can open one place, see the entire product at every breakpoint and
state, compare it to the written brief, and point at a signed approval. Only
then does implementation begin.
