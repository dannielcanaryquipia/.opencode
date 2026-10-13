# Design Brief

> **Guides look and feel.** Defines brand direction and aligns UX decisions.
> This tells an AI agent (or designer) how the product should *feel* and look,
> so UI work is consistent instead of ad-hoc.

- **Product name:** _<Product / project name>_
- **Last updated:** _<YYYY-MM-DD>_
- **Related docs:** [PRD](./PRD.md) · [App Flow](./APP-FLOW.md)

---

## 1. Project Summary

One short paragraph: what the product is, the feeling it should evoke, and the
design north star.

> **Example** — *TaskFlow should feel calm, focused, and trustworthy — a quiet
> workspace, not a noisy dashboard. Clean typography, generous whitespace, and
> restrained color keep attention on the user's work.*

- **Design principles:** _<e.g., clarity over decoration; fast over flashy; accessible by default>_
- **Tone / personality:** _<e.g., professional, friendly, minimal>_

---

## 2. Audience

Who will use the interface, and what that implies for design. (Mirror the
personas in the [PRD](./PRD.md).)

- **Primary users:** _<who, context of use — desktop at work? mobile on the go?>_
- **Accessibility needs:** _<WCAG target, contrast, keyboard nav, screen readers>_
- **Device / context:** _<primary screen sizes, lighting, attention level>_

---

## 3. Visual Direction

The overall aesthetic and mood. Describe in words and reference inspiration.

- **Style:** _<e.g., minimal, editorial, flat, soft/rounded, bold>_
- **Mood words:** _<3–5 adjectives>_
- **References / inspiration:** _<links or product names>_
- **Imagery / illustration:** _<photo style, icon style, illustration use>_
- **Do / don't:** _<e.g., do: whitespace; don't: heavy drop shadows>_

---

## 4. Color Palette

Define the palette with roles and hex values. Verify contrast ratios.

| Role | Color | Hex | Usage |
|------|-------|-----|-------|
| Primary | _<name>_ | `#______` | buttons, primary actions, links |
| Secondary | _<name>_ | `#______` | accents, highlights |
| Accent | _<name>_ | `#______` | emphasis, badges |
| Neutral / surface | _<name>_ | `#______` | backgrounds, cards |
| Text | _<name>_ | `#______` | body text |
| Success / Warning / Error | — | `#__ / #__ / #__` | status states |

> Ensure text/background pairs meet **WCAG AA (4.5:1)** for body text.

---

## 5. Typography

| Role | Font | Weight | Size / scale |
|------|------|--------|--------------|
| Display / H1 | _<font>_ | _<700>_ | _<e.g., 2.5rem>_ |
| Heading | _<font>_ | _<600>_ | _<scale>_ |
| Body | _<font>_ | _<400>_ | _<1rem / 16px>_ |
| Caption / small | _<font>_ | _<400>_ | _<0.875rem>_ |

- **Type scale:** _<e.g., 1.25 modular scale>_
- **Line height / spacing:** _<body 1.5, headings 1.2>_

---

## 6. Key Screens

The screens that define the experience (align with the [App Flow](./APP-FLOW.md)).
For each, note the layout intent and primary action.

| Screen | Layout intent | Primary action |
|--------|---------------|----------------|
| Login / Sign up | centered card, minimal | log in |
| Dashboard | overview grid / list, clear hierarchy | create / open task |
| Create Task | focused form, few fields | save task |
| View Tasks | scannable list/board, status visible | change status |
| Settings | simple settings list | save changes |

- **Wireframe notes / links:** _<link to mockups, Figma, or sketches>_

---

## 7. Components & Patterns

- **Core components:** _<buttons, inputs, cards, modals, nav, toasts>_
- **States to design:** default, hover, focus, active, disabled, loading, empty, error.
- **Spacing system:** _<e.g., 4px base grid — 4, 8, 12, 16, 24, 32>_
- **Radius / elevation:** _<corner radius, shadow usage>_
- **Responsive breakpoints:** _<mobile / tablet / desktop widths>_

---

### How the AI agent should use this doc
1. Apply the **palette and typography (§4–§5)** consistently — don't invent new
   colors or fonts per screen.
2. Build the **design states (§7)** for every interactive component, including
   empty and error states.
3. Keep screen layouts aligned with the [App Flow](./APP-FLOW.md).
4. Meet the **accessibility bar** in §2 (contrast, keyboard navigation).
