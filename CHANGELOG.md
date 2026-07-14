# Changelog

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
