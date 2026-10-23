# Screen Map

> Design-phase artifact. Defines every screen, route, state and breakpoint
> before any feature code is written. Fill this from `APP-FLOW.md` and the PRD.

- **Project:** _<name>_
- **Version:** _<v0.1>_
- **Last updated:** _<YYYY-MM-DD>_
- **Design owner:** _<name>_

---

## 1. Screens

One row per route. Keep names identical to `APP-FLOW.md` and the component
inventory.

| # | Screen | Route | Purpose | Primary action | Entry from | Exits to | Data shown |
|---|--------|-------|---------|----------------|------------|----------|------------|
| 1 | _<Home>_ | _</>_ | _<what it is for>_ | _<one action>_ | _<launch / link>_ | _<route>_ | _<fixtures>_ |
| 2 | _<...>_ | _<...>_ | _<...>_ | _<...>_ | _<...>_ | _<...>_ | _<...>_ |

---

## 2. State matrix

Every screen must define these states. Mark `n/a` only when the state is
genuinely impossible.

| Screen | Default | Loading | Empty | Error | Success | Disabled | Hover / focus |
|--------|---------|---------|-------|-------|---------|----------|---------------|
| _<Home>_ | yes | _<skeleton>_ | _<copy + CTA>_ | _<message + retry>_ | _<toast>_ | _<...>_ | yes |
| _<...>_ | | | | | | | |

Rules:

- Loading uses skeletons that match the final layout; no layout shift.
- Empty states have one explanation and one primary action.
- Errors say what failed and what the user can do next.
- Success is visible without a full page reload.

---

## 3. Responsive behavior

| Screen | 390 (mobile) | 768 (tablet) | 1440 (desktop) |
|--------|--------------|--------------|----------------|
| _<Home>_ | _<stacked, nav drawer>_ | _<2-col>_ | _<3-col, sticky rail>_ |
| _<...>_ | | | |

Note what reflows, what hides, and what becomes a drawer/sheet. No hover-only
actions on touch.

---

## 4. Flows

List the primary paths and their branches. Each step names a screen from
section 1.

### Flow A — _<first-time user>_
1. _<screen>_ -> _<action>_ -> _<screen>_
2. _<...>_
   - Error branch: _<...>_

### Flow B — _<returning user>_
1. _<...>_

---

## 5. Scope check

- Screens in this map: _<n>_
- New screens vs `APP-FLOW.md`: _<none / list + reason>_
- Deferred to P1: _<list>_
- Not designed on purpose: _<list + reason>_

Any new screen after approval is a change-control entry, not a silent addition.
