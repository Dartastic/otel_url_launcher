# Changelog

## [0.1.0-beta.1-wip]

### Added

- `tracedLaunchUrl(url, ...)` — wraps `launchUrl` with a CLIENT
  span carrying `url.full`, `url.scheme`,
  `url_launcher.operation=launch`.
- `tracedCanLaunchUrl(url)` — same wrap for `canLaunchUrl`.
- `tracedUrlLauncherCall<R>` — generic helper.
- Zone-scoped suppression
  (`runWithoutUrlLauncherInstrumentation` / async variant).
- 3 tests.
