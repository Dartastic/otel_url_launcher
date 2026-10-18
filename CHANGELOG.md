# Changelog

## [0.2.1] - 2026-10-18

### Changed

- README: standard header naming the instrumented library, its supported platforms and project links; pubspec description to match.

## [0.2.0] - 2026-10-11

### Changed

- Requires `dartastic_opentelemetry_api >=1.0.0-rc.4 <1.0.0-rc.5`.
- **Breaking:** depends on `dartastic_opentelemetry_api` only, no
  longer on the SDK. The application chooses and initializes the
  OpenTelemetry SDK. Parameters and fields typed with SDK classes
  now use the API types (`APITracer`, `APISpan`, `APILogger`, ...);
  SDK instances are still accepted wherever an API type is expected.

## [0.1.0] - 2026-08-10

### Added

- `tracedLaunchUrl(url, ...)` — wraps `launchUrl` with a CLIENT
  span carrying `url.full`, `url.scheme`,
  `url_launcher.operation=launch`.
- `tracedCanLaunchUrl(url)` — same wrap for `canLaunchUrl`.
- `tracedUrlLauncherCall<R>` — generic helper.
- Zone-scoped suppression
  (`runWithoutUrlLauncherInstrumentation` / async variant).
- `UrlLauncherSemantics` enum — the `url_launcher.operation`
  attribute key as a typed constant.
- `example/example.md`.
- 3 tests.

### Changed

- `url_launcher` floor raised to `^6.1.0`, where `launchUrl`,
  `LaunchMode`, and `WebViewConfiguration` first exist.
