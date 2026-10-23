# Design Tokens — Animation

> Canonical animation values for all projects. The `web-animation` skill reads these.
>
> Project-specific tokens are locked during `design-phase` (D2) and recorded in
> the project's `docs/design/DESIGN-SYSTEM.md`; this file is the default bank.

---

## Easing

| Token | Value | Use |
|-------|-------|-----|
| `ease-out-expo` | `[0.16, 1, 0.3, 1]` | Default for all Motion/CSS transitions |
| `ease-in-out-smooth` | `[0.4, 0, 0.2, 1]` | Multi-step transitions |
| `ease-spring` | spring with stiffness 300, damping 24 | Bouncy interactions |
| `ease-bounce` | spring with stiffness 400, damping 10 | Playful emphasis |

## Durations

| Token | Value | Use |
|-------|-------|-----|
| `duration-instant` | `100ms` | Micro-feedback (button press) |
| `duration-fast` | `150ms` | Hover states, toggles |
| `duration-normal` | `200ms` | Card hover, tooltips |
| `duration-slow` | `400ms` | Page-level reveals |
| `duration-entrance` | `600ms` | Section entrance animations |
| `duration-route` | `200ms` | Route/page crossfade |

## Entrance Animations

| Pattern | Properties | Duration | Easing |
|---------|-----------|----------|--------|
| Fade in | `opacity: 0→1` | 600ms | ease-out-expo |
| Slide up | `opacity: 0→1, y: 20→0` | 600ms | ease-out-expo |
| Slide from left | `opacity: 0→1, x: 40→0` | 600ms | ease-out-expo |
| Slide from right | `opacity: 0→1, x: -40→0` | 600ms | ease-out-expo |
| Scale in | `opacity: 0→1, scale: 0.95→1` | 400ms | ease-out-expo |

## Micro-Interactions

| Pattern | Properties | Duration | Easing |
|---------|-----------|----------|--------|
| Button hover | `scale: 1.02` | 150ms | ease-out-expo |
| Button press | `scale: 0.98` | 100ms | ease-out-expo |
| Card hover | `translateY: -2px, shadow` | 200ms | ease-out-expo |
| Link underline | `width: 0→100%` | 200ms | ease-out-expo |

## Stagger

| Pattern | Delay per child | Use |
|---------|----------------|-----|
| List reveal | `100ms` | Feature lists, nav items |
| Grid reveal | `80ms` | Card grids, image galleries |
| Hero cascade | `150ms` | Title → subtitle → CTA sequence |

## Banned Patterns

- **Scroll-jacking / hijacked wheel** — never trap or override native scroll velocity, `scroll-behavior`, or Lenis settings to fight the user. Lenis smoothing is fine; aggressive forced-scroll is not.
- **Infinite loops** — except loading indicators (spinner, shimmer)
- **Typing animations** — character-by-character reveal
- **Layout thrashing** — never animate `width`, `height`, `top`, `left`, `margin`, `padding`
- **Vision-breaking scroll** — no scroll-linked effects that hide content or trap the page (e.g. "scroll to unlock", velocity-required reveals)
- **Unscoped scroll-driven animations** — every ScrollTrigger / `useScroll` must declare a trigger element; no global-position displacement of non-triggered content

## Scroll-Driven Animation (Apple-style product pages)

Scroll-driven and pin/scrub animation **is allowed and preferred** for product/marketing sites that want Apple-style motion. Rules:

1. Scope to a trigger: `scrollTrigger: { trigger: ".section" }` or Motion `useScroll({ target: ref })`.
2. **Scrub** is the Apple default — progress maps to scroll position (`scrub: 1`); never auto-play unrelated elements from a scroll event.
3. `pin: true` requires a defined `end` and a scroll-position fallback; keep pinned sections short so the page still reads as a page.
4. Animate **only** `transform` and `opacity`; rotate/scale a parent wrapper, never per-sprite layout props.
5. Respect `prefers-reduced-motion` via `gsap.matchMedia()` / Motion `useReducedMotion` — this is the one scripted path where reduced-motion support is *required*, not optional.

```javascript
// Example: scroll-scrubbed 3D wrapper (Apple-style)
gsap.utils.toArray(".reveal").forEach((el) => {
  gsap.to(el, {
    scale: 0.9,
    opacity: 1,
    scrollTrigger: {
      trigger: el,
      start: "top 80%",
      end: "top 30%",
      scrub: 1
    }
  });
});
```

Lenis (smooth scroll) is optional and desktop-only; fall back to native scroll on coarse pointers. Lazy-init WebGL and pause the render loop when the scene leaves the viewport.

## Performance Rules

1. Only animate `transform` and `opacity` (GPU-composited)
2. Use `will-change: transform` before animation, remove after
3. Prefer CSS transitions for simple hover states (no JS overhead)
4. Use Motion's `layout` prop for layout animations
5. Always check `prefers-reduced-motion` and disable animations if set

## Accessibility

Every animation pattern MUST include:

```tsx
// Framer Motion
const prefersReduced = useReducedMotion();
if (prefersReduced) return <div>{children}</div>;

// CSS fallback
@media (prefers-reduced-motion: reduce) {
  * { animation: none !important; transition: none !important; }
}
```
