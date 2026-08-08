// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'dart:async';

const Symbol _suppressKey = #otel_url_launcher_suppress;

/// Whether url_launcher instrumentation is suppressed in the current
/// [Zone].
///
/// `true` inside [runWithoutUrlLauncherInstrumentation] /
/// [runWithoutUrlLauncherInstrumentationAsync] bodies; the traced
/// wrappers then invoke the underlying call without opening a span.
bool urlLauncherInstrumentationSuppressed() {
  return Zone.current[_suppressKey] == true;
}

/// Runs [body] with url_launcher instrumentation suppressed: traced
/// wrappers called inside it emit no spans.
T runWithoutUrlLauncherInstrumentation<T>(T Function() body) {
  return runZoned(body, zoneValues: {_suppressKey: true});
}

/// Async variant of [runWithoutUrlLauncherInstrumentation]: awaits
/// [body] with instrumentation suppressed for the whole async flow.
Future<T> runWithoutUrlLauncherInstrumentationAsync<T>(
  Future<T> Function() body,
) {
  return runZoned(body, zoneValues: {_suppressKey: true});
}
