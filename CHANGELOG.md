# Changelog

## [1.0.0-wip]

### Changed

- Requires `dartastic_opentelemetry ^1.1.0-beta.17` and
  `dartastic_opentelemetry_api >=1.0.0-rc.4 <1.0.0-rc.5`.
- First 1.0 release: the public API of this package is stable and
  follows semantic versioning from here on.

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
