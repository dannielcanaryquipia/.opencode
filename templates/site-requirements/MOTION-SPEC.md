# MOTION-SPEC — storyboard & recipe bank

This document is the **motion + visualization contract** for the build. The AI
implements each section straight from the tables below; you never have to write
GSAP. Replace the AURA example rows with your own words before Phase 3.

This file is filled during `design-phase` (D5) and frozen in
`DESIGN-APPROVAL.md`; no motion code is written before that sign-off.

## Recipe bank

| ID | Recipe | Best for |
|----|--------|----------|
| R1 | Cinematic reveal — SplitText entrance, mask wipe, float settle | hero, footer |
| R2 | Pinned 3D spin (scrub) — scroll rotates the model, swaps finish/texture per text block | product/model |
| R3 | Parallax drift — layered background movement, small travel | backgrounds, specs |
| R4 | Horizontal gallery — section pins, cards scrub across the track, video progress rail | highlights |
| R5 | Stripe wipe sequence — head/glyph break, cards on motion paths, accent stripe wipes out | features |
| R6 | Stat counters — count + fade on scroll-in | specs |
| R7 | Marquee + magnetic CTA — endless type, cursor-pull buttons | closing CTA |

## Storyboard (AURA example — replace with your client's, then update `site.config.ts`)

| Section | What do you want to visualize? (your words) | Element | Recipe | Scroll | Mood / color | Reduced-motion fallback |
|---------|---------------------------------------------|---------|--------|--------|--------------|-------------------------|
| hero | Headset floats above a soft halo; headline writes itself in as you enter | 3D + type | R1 | entrance | dark, cinematic, quiet · indigo halo | Static hero, headline visible, 3D becomes a still |
| highlights | Horizontal gallery of 4 feature films, autoplaying, with a progress rail | video | R4 | horizontal | editorial, amber + indigo | Vertical stacked cards |
| model | Pinned close-up 3D; scrolling rotates the headset and swaps finishes per text block | 3D | R2 | scrub | studio, cold steel | 3D gyro still + text blocks stacked |
| features | Headline breaks, cards drift along motion paths, accent light wipes the stripe out | type + cards | R5 | pin | electric, indigo flares | Cards fade in place, no pin |
| specs | Parallax drift layers and statistic counters tick in | counters + bg | R6 | parallax | clean, white-on-black | Static counters, no parallax |
| cta | Magnetic buy button, type marquee, closing statement echoes the hero | type + button | R7 | none | calm, resolve | Static button, no marquee |
| footer | Minimal footer, magnetic social icons | brand | R1 | none | quiet | Static links |

## Target platform notes (hold these during build)

- ~8–10s per pinned section on desktop; `scrollTrigger.start: 'top top'`, `end: '+=150%'` unless the section says otherwise.
- Asset rarity: a cinematic feel mostly comes from **timing + ease `[0.16,1,0.3,1]`**, not from extra clips.
- Validate with `npm run assets:check` and the `/wireframe.html` review page before Phase 3.