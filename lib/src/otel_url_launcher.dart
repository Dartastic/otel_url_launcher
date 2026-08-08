// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:url_launcher/url_launcher.dart';

import 'url_launcher_semantics.dart';
import 'url_launcher_suppression.dart';

const _tracerName = 'otel_url_launcher';

Tracer _tracer() => OTel.tracerProvider().getTracer(_tracerName);

/// Generic helper. Opens a CLIENT span carrying the `url.*` attrs.
Future<R> tracedUrlLauncherCall<R>({
  required String operation,
  required Uri url,
  required Future<R> Function() invoke,
}) async {
  if (urlLauncherInstrumentationSuppressed()) return invoke();
  final span = _tracer().startSpan(
    'url_launcher $operation',
    kind: SpanKind.client,
    attributes: OTel.attributesFromMap(<String, Object>{
      Url.urlFull.key: url.toString(),
      Url.urlScheme.key: url.scheme,
      UrlLauncherSemantics.operation.key: operation,
    }),
  );
  try {
    return await invoke();
  } catch (e, st) {
    span.addAttributes(OTel.attributes([
      OTel.attributeString(
        ErrorAttributes.errorType.key,
        e.runtimeType.toString(),
      ),
    ]));
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}

/// Traced `launchUrl`. Returns the same `bool` (`true` if launched).
Future<bool> tracedLaunchUrl(
  Uri url, {
  LaunchMode mode = LaunchMode.platformDefault,
  WebViewConfiguration webViewConfiguration = const WebViewConfiguration(),
  String? webOnlyWindowName,
}) {
  return tracedUrlLauncherCall<bool>(
    operation: 'launch',
    url: url,
    invoke: () => launchUrl(
      url,
      mode: mode,
      webViewConfiguration: webViewConfiguration,
      webOnlyWindowName: webOnlyWindowName,
    ),
  );
}

/// Traced `canLaunchUrl`.
Future<bool> tracedCanLaunchUrl(Uri url) {
  return tracedUrlLauncherCall<bool>(
    operation: 'can_launch',
    url: url,
    invoke: () => canLaunchUrl(url),
  );
}
