# PLAN — requirements-driven site build

Manifest-first, design-gated build process. The user supplies requirements,
assets and intent; the AI never guesses files, copy or components.

## Phase 1 — Requirements & scaffold

- Fill the context pack in `needed-documents/`: PRD, TRD, App Flow, Design Brief.
- Copy this scaffold into the project and fill `site.config.ts`.
- Complete `ASSET-MANIFEST.md` slots; unresolved slots stay `placeholder`.
- Run `npm run assets:check` and confirm every slot reports `[OK]`,
  `[PLACEHOLDER]` or `[MISSING]`.
- Fill `MOTION-SPEC.md` storyboard rows with the user's own words.

**Done when:** the config is valid, every asset slot is accounted for, and no
value is invented.

## Phase 2 — Design gate (mandatory)

Load `skills/design-phase/SKILL.md` and produce:

- `docs/design/SCREEN-MAP.md` — every route, state and breakpoint
  (`templates/design-phase/SCREEN-MAP.md`).
- `docs/design/DESIGN-SYSTEM.md` — locked color, type, spacing, radius and
  motion tokens.
- `docs/design/COMPONENT-INVENTORY.md` — every element mapped to an `@esuiss`
  item or a justified custom build
  (`templates/design-phase/COMPONENT-INVENTORY.md`).
- A component lab and static screens at 390 / 768 / 1440.
- `docs/design/DESIGN-APPROVAL.md` with evidence and a named sign-off
  (`templates/design-phase/DESIGN-APPROVAL.md`).

**Done when:** the approval file is signed and the frozen file list is recorded.

**Stop rule:** no Development work starts until the approval is signed.

## Phase 3 — Assets & motion lock

- Drop supplied files into `public/assets/` and flip `status` to `supplied`.
- Re-run `npm run assets:check`.
- Finalize each storyboard row: recipe, scroll pattern, mood and
  reduced-motion fallback.
- Confirm every scroll trigger is scoped and `prefers-reduced-motion` is gated.

**Done when:** assets check clean and the motion spec matches the approved
design.

## Phase 4 — Build

- Build the shell from `site.config.ts` (title, favicon, OGP, nav, tokens).
- Implement sections in storyboard order, reading copy and assets from config.
- Use only approved components; record any substitution.
- Animate `transform` and `opacity` only; no layout animation, scroll-jacking
  or unbounded loops.
- Render missing assets as labeled `PlaceholderSlot`s, never as guesses.

**Done when:** every approved screen and state exists in code.

## Phase 5 — Verify & reuse

- Playwright: scroll-through, all breakpoints, console clean, placeholders
  labeled, reduced-motion emulation, keyboard pass.
- Lighthouse targets agreed in the TRD.
- `qa-review` runs the completion gate and, for client/public sites, the
  `website-compliance-checklist`.
- Feed improvements back into `templates/design-phase/` and this plan.

**Done when:** evidence is attached and QA approves.

## Ground rules

- One approved design, one component inventory, one motion spec.
- Change control: update the design docs and re-sign before changing the build.
- If two documents disagree, stop and flag the conflict instead of guessing.
