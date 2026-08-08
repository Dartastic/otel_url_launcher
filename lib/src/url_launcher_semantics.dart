// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

/// url_launcher-specific attribute keys that have no upstream
/// semantic-convention registry entry.
///
/// The registry's `url.*` keys ([Url.urlFull], [Url.urlScheme]) cover
/// the URL itself; this enum covers the launcher-side facts. There is
/// no registry convention for OS URL dispatch, so these stay under a
/// package-named prefix. When the registry grows one, these can
/// `@Deprecated`-pivot.
enum UrlLauncherSemantics implements OTelSemantic {
  /// Which url_launcher call produced the span: `launch` or
  /// `can_launch`.
  operation('url_launcher.operation');

  const UrlLauncherSemantics(this.key);

  @override
  final String key;

  @override
  String toString() => key;
}
