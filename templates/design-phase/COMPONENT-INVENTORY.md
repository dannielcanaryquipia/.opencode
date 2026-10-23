# Component Inventory

> Design-phase artifact. One row per UI element, mapped to a source before
> building. Search the `@esuiss` registry first; build custom only when no item
> fits. This list and the component lab are the proof that the whole UI was
> designed before development.

- **Project:** _<name>_
- **Version:** _<v0.1>_
- **Design system:** _<e.g. suiss `radix-nova` / custom>_
- **Icon library:** _<e.g. lucide>_

---

## 1. Inventory

Status vocabulary: `planned` -> `added` -> `adapted` -> `approved`.
Type: `ui` (primitive), `pattern`, `interaction`, `chart`, `block`, `custom`.

| # | Component | Type | Source | Used on | States | Status | Notes |
|---|-----------|------|--------|---------|--------|--------|-------|
| 1 | Button | ui | `@esuiss/button` | all | default, hover, focus, disabled, loading | planned | keep 4 variants only |
| 2 | Dialog | ui | `@esuiss/dialog` | settings | default, open, loading | planned | |
| 3 | Hero | block | `@esuiss/hero-product` | home | desktop, mobile, reduced-motion | planned | replace copy + image |
| 4 | Stat row | block | `@esuiss/bento-stats` | home, pricing | default, loading | planned | 3 stats, not 6 |
| 5 | _<...>_ | | | | | | |

Rules:

- Every interactive element lists hover, focus, active, disabled and loading.
- Every data surface lists empty and error.
- A `block` is used only when its layout matches the screen map; otherwise
  compose it from primitives/patterns.
- Record adaptations (tokens, variants removed, copy) in Notes.
- No duplicate components for the same job under different names.

---

## 2. Custom-build log

Only for items with no reasonable `@esuiss` match.

| Component | Why custom | Smallest scope | Owner | Status |
|-----------|------------|----------------|-------|--------|
| _<...>_ | _<no match / behavior differs>_ | _<CSS-only / single component>_ | _<name>_ | planned |

If the reason is "I did not search", go back to section 1.

---

## 3. Coverage check

- Elements on screens: _<n>_
- Rows in inventory: _<n>_
- From `@esuiss`: _<n>_
- Custom: _<n>_
- Missing states: _<none / list>_
- Screens with an element missing from the inventory: _<none / list>_

---

## 4. Summary for approval

- Total items: _<n>_
- `approved`: _<n>_ / `planned`: _<n>_
- New dependencies introduced: _<list>_
- Open questions: _<list>_

The inventory is frozen at design sign-off; additions go through change control.
