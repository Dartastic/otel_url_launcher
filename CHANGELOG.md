# Changelog

## [0.2.0-wip]

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
