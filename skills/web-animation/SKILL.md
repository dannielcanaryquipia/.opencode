---
name: web-animation
description: Add motion to React web interfaces with Motion (Framer Motion) and CSS — entrance animations, scroll reveals, staggered lists, page transitions, micro-interactions, hover effects and loading states. Use when the user says "animate this", "add motion", "scroll reveal", "fade in", "page transition", "hover effect" or "make it feel alive". Every pattern includes prefers-reduced-motion support.
---

# Web Animation Skill

> Add animations, scroll effects, micro-interactions, and motion to any React project.

---

## Triggers

Use this skill when the user says:
- "animate this", "add animation", "make it alive"
- "add scroll effects", "scroll reveal", "fade in on scroll"
- "page transitions", "route animation"
- "hover effects", "micro-interactions", "hover card"
- "loading states", "skeleton", "shimmer", "spinner"
- "parallax", "scroll-driven"
- "add motion", "make it smooth"

## Animation Toolkit

| Tool | Status | Use For |
|------|--------|---------|
| **Motion (Framer Motion)** | Primary | React component animation, layout, gestures, page transitions |
| **CSS Transitions** | Built-in | Hover states, color changes, simple toggles |
| **CSS Keyframes** | Built-in | Loading spinners, shimmer, pulse, float loops |
| **GSAP** | Optional | Complex timelines, scroll sequences, SVG morphing |

## Design Tokens

All animations use these defaults (override via props):

- **Easing:** `[0.16, 1, 0.3, 1]` (ease-out-expo)
- **Page entrance:** 600ms, `opacity 0→1` + `y: 20→0`
- **Route transition:** 200ms crossfade
- **Button hover:** 150ms, `scale: 1.02`
- **Card hover:** 200ms, `translate-y: -2px` + shadow

## Banned Patterns

- No scroll-jacking / wheel-hijacking (Lenis smoothing ok; forced scroll not)
- No infinite loops (except loading indicators)
- No typing animations
- No layout-thrashing properties (width, height, top, left in animations)
- No unscoped scroll-driven motion — every ScrollTrigger / `useScroll` needs a trigger element

## Scroll-Driven Animation (Apple-style)

Pin/scrub scroll animation — the Apple product-page effect — is allowed when *scoped and reduced-motion-safe*:

```tsx
import { useScroll, useTransform, motion } from "framer-motion";

function Showcase({ targetRef }) {
  const { scrollYProgress } = useScroll({ target: targetRef, offset: ["start start", "end end"] });
  const rotateY = useTransform(scrollYProgress, [0, 1], [0, 90]);
  return <motion.div style={{ rotateY }} />;
}
```

GSAP equivalent (pin + scrub), best for timelines with 3D scenes:

```javascript
gsap.to(".model", {
  rotationY: 90,
  scrollTrigger: { trigger: ".showcase", start: "top top", end: "bottom bottom", scrub: 1, pin: true }
});
```

Rules: scope every trigger, keep pins short, animate only transform/opacity, and gate with `gsap.matchMedia()` / `useReducedMotion`. Full recipe in `OPEN-SOURCE-TEMPLATES.md` (R3F + GSAP + Lenis Apple-style stack).

## Performance Rules

1. Only animate `transform` and `opacity` (GPU-accelerated)
2. Use `will-change` sparingly and remove after animation
3. Prefer CSS transitions for simple hover states
4. Use Motion's `layout` for layout animations
5. Always support `prefers-reduced-motion`

## Accessibility

Every pattern MUST include reduced-motion support:

```tsx
// Motion
const prefersReduced = useReducedMotion();

// CSS
@media (prefers-reduced-motion: reduce) {
  * { animation: none !important; transition: none !important; }
}
```

## Components

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

## Page Transitions (React Router + AnimatePresence)

```tsx
import { AnimatePresence, motion } from "framer-motion";
import { useLocation } from "react-router-dom";

const pageVariants = {
  initial: { opacity: 0, y: 20 },
  animate: { opacity: 1, y: 0, transition: { duration: 0.6, ease: [0.16, 1, 0.3, 1] } },
  exit: { opacity: 0, y: -10, transition: { duration: 0.2 } },
};

function AnimatedRoutes() {
  const location = useLocation();
  return (
    <AnimatePresence mode="wait">
      <motion.div
        key={location.pathname}
        variants={pageVariants}
        initial="initial"
        animate="animate"
        exit="exit"
      >
        <Routes location={location}>
          {/* routes */}
        </Routes>
      </motion.div>
    </AnimatePresence>
  );
}
```

## Loading States

```tsx
// Shimmer skeleton
<div className="animate-pulse bg-muted rounded h-4 w-full" />

// Spinner
<motion.div
  animate={{ rotate: 360 }}
  transition={{ duration: 1, repeat: Infinity, ease: "linear" }}
  className="w-5 h-5 border-2 border-current border-t-transparent rounded-full"
/>

// Pulse dot
<motion.div
  animate={{ scale: [1, 1.2, 1] }}
  transition={{ duration: 1.5, repeat: Infinity }}
  className="w-2 h-2 bg-primary rounded-full"
/>
```

## When to Add GSAP

Install GSAP when you need:
- Complex sequenced timelines (`gsap.timeline()`)
- Scroll-linked scrub animation (`ScrollTrigger`)
- SVG morphing between shapes
- Draggable elements

```bash
npm install gsap
```

## Related Skills

| Skill | Covers |
|-------|--------|
| `radix-ui` | Radix Themes / Primitives UI layer to wrap in motion |
| `gsap-core` | GSAP core API, tweens, easing, stagger |
| `emilkowalski-motion` | Tasteful micro-interactions with restraint |
| `design-taste-frontend` | Anti-slop frontend with motion dial |
| `impeccable-design-polish` | Post-build polish and animation hardening |
| `OPEN-SOURCE-TEMPLATES.md` | Apple-style R3F + GSAP + Lenis template index |
