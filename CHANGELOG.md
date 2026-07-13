# Changelog

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
