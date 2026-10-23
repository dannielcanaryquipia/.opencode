# Web Animation Skill

> `.opencode/skills/web-animation/` — what it is, what it covers, and how to use it.

---

## What This Is

A reusable **opencode skill** that gives the AI agent everything it needs to add animations to this project. When you say things like "animate this", "add scroll effects", "make it alive", or "add a fade-in", the agent loads this skill and follows its patterns.

In a full build, `design-phase` runs first: the approved `MOTION-SPEC.md` decides what moves, and this skill implements it.

## What's Inside

```
.opencode/skills/web-animation/
├── SKILL.md              # The full skill definition (triggers, patterns, rules)
├── index.ts              # Barrel exports for quick imports
├── hooks/
│   └── useScrollReveal.ts   # Vanilla scroll-trigger hook (no deps)
└── components/
    ├── RevealSection.tsx     # Scroll-triggered fade-in wrapper
    ├── StaggerContainer.tsx  # Sequential children reveal
    ├── FadeIn.tsx            # Simple mount/unmount animation
    └── HoverCard.tsx         # Hover micro-interaction card
```

## Animation Tools Covered

| Tool | Status | When to Use |
|------|--------|-------------|
| **Motion (Framer Motion)** | Installed | React component animation, layout, gestures, page transitions |
| **CSS Transitions** | Built-in | Hover states, color changes, simple toggles |
| **CSS Keyframes** | Built-in | Loading spinners, shimmer, pulse, float loops |
| **GSAP** | Not installed | Complex timelines, scroll sequences, SVG morphing |

## What the Skill Teaches

- **Entrance animations** — fade-in, slide-up, staggered lists
- **Scroll reveals** — elements animate when scrolled into view
- **Page transitions** — crossfade between routes via React Router + AnimatePresence
- **Micro-interactions** — hover cards, toggle switches, accordions, tooltips, toasts
- **Loading states** — shimmer skeletons, spinners, pulse effects
- **Scroll-driven** — parallax, progress-linked animations, CSS scroll-driven APIs
- **Accessibility** — every pattern includes `prefers-reduced-motion` support
- **Performance** — GPU-accelerated properties only, no layout thrashing

## How to Use the Components

### RevealSection — fade in on scroll

```tsx
import { RevealSection } from ".opencode/skills/web-animation";

<RevealSection>
  <h2>This appears when you scroll to it</h2>
</RevealSection>

<RevealSection delay={0.15} direction="left">
  <div>Delayed, slides in from the left</div>
</RevealSection>
```

### StaggerContainer — sequential reveal

```tsx
import { StaggerContainer, StaggerItem } from ".opencode/skills/web-animation";

<StaggerContainer>
  <StaggerItem>First item</StaggerItem>
  <StaggerItem>Second item</StaggerItem>
  <StaggerItem>Third item</StaggerItem>
</StaggerContainer>
```

### FadeIn — mount animation

```tsx
import { FadeIn } from ".opencode/skills/web-animation";

<FadeIn slide delay={0.2}>
  <p>Slides up 200ms after mount</p>
</FadeIn>
```

### HoverCard — interactive hover

```tsx
import { HoverCard } from ".opencode/skills/web-animation";

<HoverCard className="bg-surface border rounded-lg">
  <CardContent>Hover me for a subtle lift</CardContent>
</HoverCard>
```

### useScrollReveal — vanilla hook (no Motion)

```tsx
import { useScrollReveal } from ".opencode/skills/web-animation";

const { ref, isVisible } = useScrollReveal();

<div
  ref={ref}
  className={`transition-all duration-600 ${isVisible ? "opacity-100" : "opacity-0"}`}
>
  Plain CSS version
</div>
```

## Design Tokens Used

All animations respect the project's existing design system from `DESIGN.md`:

- **Easing:** `[0.16, 1, 0.3, 1]` (ease-out-expo) for all transitions
- **Page entrance:** 600ms, `opacity 0→1` + `y: 20→0`
- **Route transition:** 200ms crossfade
- **Button hover:** 150ms, `scale: 1.02`
- **Card hover:** 200ms, `translate-y: -2px` + shadow
- **Banned:** No scroll-jacking, no infinite loops, no typing animations, no layout-thrashing props

## Apple-Style Scroll (pin + scrub)

Scroll-driven animation is **allowed and preferred** for product/marketing pages. See
`DESIGN.md` → "Scroll-Driven Animation" for the rules and `OPEN-SOURCE-TEMPLATES.md`
for the R3F + GSAP + Lenis stack and open-source clones to copy from.

## When to Add GSAP

GSAP is not currently installed. Add it when you need:

- Complex sequenced timelines (`gsap.timeline()`)
- Scroll-linked scrub animation (`ScrollTrigger`)
- SVG morphing between shapes
- Draggable elements

```bash
npm install gsap
```

The `gsap-core` skill at `.opencode/skills/gsap-core/` covers GSAP patterns in detail.

## Related Skills

| Skill | Location | Covers |
|-------|----------|--------|
| **web-animation** | `.opencode/skills/web-animation/` | This skill — React Motion, CSS, scroll, micro-interactions |
| **gsap-core** | `.opencode/skills/gsap-core/` | GSAP core API, tweens, easing, stagger |
| **emilkowalski-motion** | `.opencode/skills/emilkowalski-motion/` | Tasteful micro-interactions with restraint |
| **design-taste-frontend** | `.opencode/skills/design-taste-frontend/` | Anti-slop frontend with motion dial |
| **impeccable-design-polish** | `.opencode/skills/impeccable-design-polish/` | Post-build polish and animation hardening |
