# Design Approval

> Sign-off gate between design and development. Development starts only when
> every gate is checked and this page is signed. Keep it in the repo next to the
> screen map and component inventory.

- **Project:** _<name>_
- **Design version:** _<v0.1>_
- **Date:** _<YYYY-MM-DD>_
- **Approver:** _<name, role>_
- **Reviewers:** _<names>_

---

## Gate 1 — Inputs

- [ ] PRD scope and P0 features are final.
- [ ] App Flow matches the screen map (no extra or missing screens).
- [ ] Design Brief has palette, type, mood and do/don't.
- [ ] Placeholder copy and assets are labeled, not invented.

## Gate 2 — Screens

- [ ] Every screen in the screen map exists in the static prototype.
- [ ] Every screen renders at 390 / 768 / 1440.
- [ ] Primary action per screen is obvious without explanation.
- [ ] Navigation and entry/exit paths match the App Flow.

## Gate 3 — Tokens

- [ ] One token source (`DESIGN-TOKENS.md` or theme item).
- [ ] Color roles are used consistently; no per-screen hex values.
- [ ] Type scale and spacing scale are applied to every screen.
- [ ] Body text passes 4.5:1; large text and UI boundaries pass 3:1.
- [ ] Focus ring is visible on every interactive element.

## Gate 4 — Components

- [ ] `COMPONENT-INVENTORY.md` covers every element on every screen.
- [ ] Every row has a source (`@esuiss/...` or custom with a reason).
- [ ] No duplicate components for the same job.
- [ ] Registry items were viewed with `shadcn view` and added with `--dry-run`.
- [ ] Adaptations are recorded (variants removed, tokens, copy).

## Gate 5 — States and responsive

- [ ] Default, hover, focus, active, disabled, loading, empty, error and success
      are reachable in the lab.
- [ ] Loading uses layout-matched skeletons; no layout shift.
- [ ] Empty and error states have a clear next action.
- [ ] Touch targets are at least 44x44 on mobile.
- [ ] No hover-only actions on touch; no horizontal scroll at 390.

## Gate 6 — Accessibility

- [ ] Keyboard path works for every flow.
- [ ] Labels, roles and alt text are present.
- [ ] Reduced-motion mode removes non-essential motion.
- [ ] Contrast and zoom (200%) were checked, not assumed.

## Gate 7 — Motion

- [ ] `MOTION-SPEC.md` is filled per section.
- [ ] Every scroll/pin/scrub is scoped to a trigger.
- [ ] Only `transform` and `opacity` animate.
- [ ] A reduced-motion fallback exists for every recipe.
- [ ] Motion budget: one hero moment, a few micro-interactions.

## Gate 8 — Evidence

Attach links or paths, not descriptions.

| Evidence | Path / URL |
|---|---|
| Component lab | _<url or path>_ |
| Static screens 390 | _<path>_ |
| Static screens 768 | _<path>_ |
| Static screens 1440 | _<path>_ |
| Motion preview | _<path>_ |
| Token file | _<path>_ |

---

## Sign-off

| Role | Name | Decision | Date |
|---|---|---|---|
| Product | _<name>_ | approved / changes requested | |
| Design | _<name>_ | approved / changes requested | |
| Engineering | _<name>_ | approved / changes requested | |

Any "changes requested" blocks development until a new version is signed.

---

## Freeze

Frozen at this version:

- [ ] `docs/design/SCREEN-MAP.md`
- [ ] `docs/design/DESIGN-TOKENS.md` / theme file
- [ ] `docs/design/COMPONENT-INVENTORY.md`
- [ ] `MOTION-SPEC.md`
- [ ] Static screens and component lab

## Change control

| Date | Change | Reason | Approved by | New version |
|------|--------|--------|-------------|-------------|
| | | | | |

After sign-off, adding a screen, changing a token or replacing a registry item
requires a row here before implementation. A silent drift check (screenshots
vs approved screens) happens after build.
