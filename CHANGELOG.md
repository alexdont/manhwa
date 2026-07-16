# Changelog

## 0.1.8 (2026-07-16)

* Smart-snap motion rebuilt on a custom rAF driver (slew-limited
  exponential approach toward the live anchor) instead of
  `scrollTo({behavior: "smooth"})`. The browser animation restarted
  from zero velocity on every mid-flight retarget (each one read as a
  stutter under lazy-load layout shifts) and the final settle
  correction landed as a visible pop; the driver follows a moving
  target continuously, so both artifacts are gone. Identical feel on
  desktop and mobile, immune to the browser cancelling its own smooth
  scroll under main-thread load, and the reader speed setting now
  scales the glide velocity. Instant jump style keeps the
  write-then-verify behavior.
* Scroll-frame diet during snap motions: the per-scroll handler work
  (dominant-chapter scan, URL/nav-label sync, progress-save timer
  churn, sessionStorage read, memory windowing) is skipped while the
  driver owns the frames — one settle-time pass runs it all when the
  motion lands. Next-chapter prefetch stays live mid-flight.

## 0.1.7 (2026-07-16)

* Fix scroll/snap jank introduced by 0.1.6's boundary flush: image
  dominance can oscillate at a chapter boundary (the snap motion's
  settle corrections nudge the viewport back and forth), and the
  flush fired a synchronous fetch inside the scroll handler on every
  flip — a burst of requests mid-animation. Boundary flushes are now
  rate-limited to one per crossing window and the fetch is deferred
  off the scroll frame.

## 0.1.6 (2026-07-15)

* Reading-time fix: crossing a chapter boundary in the infinite
  scroll now flushes accumulated time against the *outgoing* chapter
  first. Previously, finishing a chapter without a ≥500ms scroll
  pause on its last pages meant those pages were never reported —
  the host app's near-end/chapter-count logic never fired and the
  reading time was attributed to the next chapter. Scrolling down
  out of a chapter pins the report to its last page (the end was
  read through); scrolling back up flushes at the departure position.

## 0.1.5 (2026-07-14)

* Docs: the Store's page-dimensions contract now points implementors
  at the [`dims`](https://hex.pm/packages/dims) package (README wiring
  example + `fetch_pages` callback docs) — probe URLs' width × height
  cheaply instead of writing your own prober.

## 0.1.4 (2026-07-14)

* Half-stepping now keys on the exact condition — the current panel
  extending past the bottom of the viewport (unread content below the
  fold) — instead of the distance-to-next-target proxy, which stopped
  firing on narrow layouts (page padding, small windows) and skipped
  panel bottoms with trailing text bubbles. If the fold instead cuts a
  *different* panel (gutter between), the snap goes to that panel's
  start, revealing it from the top.
* The scan debounce (`min_gutter_width`, a source-px setting) now
  converts to the local rendering scale — real gutters no longer
  vanish from targeting when images render below source scale, which
  had fused panels and their text bubbles into one jump.
* The free-scroll realign special case is gone: the fold rule is
  position-exact, so arbitrary positions get the right behavior
  naturally (half-step iff the current panel crosses the fold,
  otherwise full snap to the nearest target).

## 0.1.3 (2026-07-14)

* Panel snap rebuilt to legacy fidelity: gutter detection now analyzes
  every source row at native resolution (legacy-style sparse column
  sampling, sliced canvas — same speed class as before), the landing
  rule is legacy's "first non-gutter row" (the dense-content
  adjustment is now opt-in via `smart_landing`), the phase-2 noise
  skip shrank from 2000 to 300 source-px and shares one content
  predicate (dark OR sustained-variance — pale art can no longer be
  skipped as noise) with band merging, and snaps now await detection
  for the whole scan range instead of silently degrading to a raw
  viewport jump on a cold cache.
* Gutters must match the page background, not just be flat: each image
  estimates its background from band colors (one vote per band, so
  recurring gutters out-vote any single flat art region), with
  near-white flat bands always accepted. Blurred/uniform panel
  openings no longer classify as gutters, and black-page flashback
  chapters keep their dark gutters.
* Predictive snap queue: the next 7 forward snap targets are
  precomputed from the resting position (and rebuilt on scroll/settle/
  config change), stored as layout-shift-proof anchors — a tap
  consumes a ready target with zero scan latency, and the build
  doubles as image prewarm for the panels ahead. The queue flushes
  synchronously on any manual scroll so stale chains can never skip
  targets.
* Free scrolling breaks snap alignment: the first tap afterwards goes
  straight to the nearest panel start (no long-panel half-step from an
  arbitrary position); alignment restores on any completed landing.
* Resume restore now re-anchors the saved fraction at the viewport
  center — matching how progress saves measure it — instead of the
  top, which had every "continue" landing half a viewport below where
  the user stopped.
* Snap probe offset returned to the legacy 5.5% of viewport height
  (was 10%).

## 0.1.2 (2026-07-14)

* The mouse-gesture button (bottom-right) now shows a 4-directional
  move icon instead of a down arrow, matching the OS auto-scroll
  affordance it provides.
* Middle-click (scroll-wheel button) anywhere in the reader now
  toggles mouse-gesture mode — the same gesture as OS auto-scroll.
  Middle-clicks on links/controls keep their native behavior.
* Fix: the nav's prev/next chapter arrows now retarget to the dominant
  chapter's neighbours as the strip auto-appends chapters — they were
  server-rendered against the landing chapter and went stale (the
  chapter label already synced). The next-arrow hides past the last
  known chapter instead of keeping a stale target.

## 0.1.1 (2026-07-13)

* Fix: the strip page assumed the host's user struct has a `.uuid`
  field (rendered into a dead `data-user-uuid` attribute), crashing
  the render for hosts with differently-shaped users. The Store
  contract treats the user as opaque — now the templates do too.

## 0.1.0 (2026-07-13)

Initial extraction from the Greenoak reader:

* `Manhwa.Router.manhwa_reader/2` — mounts the reader page + full API
  surface (chapter images, settings PUTs, progress, image proxy, marks,
  GIF search, debug log) under one prefix.
* `Manhwa.Store` behaviour — the host persistence contract (chapters,
  pages with dimension hints, reader state, settings, progress, proxy
  authorization, page overrides).
* `Manhwa.Annotations` / `Manhwa.GifProvider` optional adapters;
  pluggable `:etcher_host` LiveView (drawing-only default included).
* Strip reader on fresco_strip: panel-snap with per-manga tuning,
  scroll speeds, auto-reader (+ optional OCR smart delay via
  `:extra_head`), tap-zone presets, infinite next-chapter append,
  cursor-hide gesture mode, snap debugger.
