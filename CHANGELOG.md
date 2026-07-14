# Changelog

## 0.1.2 (2026-07-14)

* The mouse-gesture button (bottom-right) now shows a 4-directional
  move icon instead of a down arrow, matching the OS auto-scroll
  affordance it provides.
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
