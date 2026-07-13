defmodule Manhwa do
  @moduledoc """
  Batteries-included long-strip comic reader for Phoenix — webtoons,
  manhwa, manhua, anything that reads by scrolling.

  `manhwa` ships the whole reader experience: the strip engine
  (panel-snap, scroll speeds, auto-reader, OCR hooks) on top of
  [`fresco_strip`](https://hex.pm/packages/fresco_strip), chapter
  navigation with infinite next-chapter loading, progress persistence,
  per-series settings, an image proxy, and an optional annotation
  layer via [`etcher`](https://hex.pm/packages/etcher). It is also the
  shared core of the [`manga`](https://hex.pm/packages/manga) paged
  reader — install that instead if you want both reading modes with a
  per-series switch.

  ## Wiring

  1. Mount the routes (see `Manhwa.Router`):

         import Manhwa.Router

         scope "/" do
           pipe_through [:browser, :require_auth]
           manhwa_reader "/reader/manga"
         end

  2. Implement `Manhwa.Store` and point config at it:

         config :manhwa,
           store: MyApp.ReaderStore,
           current_user: {MyAppWeb.ReaderGlue, :current_user},
           series_url: {MyAppWeb.ReaderGlue, :series_url}

  3. Import the reader JS in your `assets/js/app.js` (fresco_strip's
     hooks; plus etcher's if you use annotations) and add the package
     to your Tailwind sources:

         @source "../../deps/manhwa";

  Optional adapters — `Manhwa.Annotations`, `Manhwa.GifProvider`, and
  the `:etcher_host` LiveView — light up annotations, the GIF picker,
  and comment threads; without them the reader simply renders without
  those affordances.
  """
end
