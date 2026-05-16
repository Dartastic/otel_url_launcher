// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otel_url_launcher/otel_url_launcher.dart';

class _MemorySpanExporter implements SpanExporter {
  final List<Span> spans = [];
  bool _shutdown = false;

  @override
  Future<void> export(List<Span> s) async {
    if (_shutdown) return;
    spans.addAll(s);
  }

  @override
  Future<void> forceFlush() async {}

  @override
  Future<void> shutdown() async {
    _shutdown = true;
  }
}

Map<String, Object> _attrs(Span span) =>
    {for (final a in span.attributes.toList()) a.key: a.value};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('tracedUrlLauncherCall', () {
    late _MemorySpanExporter exporter;

    setUp(() async {
      await OTel.reset();
      exporter = _MemorySpanExporter();
      await OTel.initialize(
        serviceName: 'url-launcher-otel-test',
        detectPlatformResources: false,
        spanProcessor: SimpleSpanProcessor(exporter),
      );
    });

    tearDown(() async {
      await OTel.shutdown();
      await OTel.reset();
    });

    test('emits CLIENT span with url.* attrs', () async {
      await tracedUrlLauncherCall<bool>(
        operation: 'launch',
        url: Uri.parse('https://example.com/page'),
        invoke: () async => true,
      );

      final span = exporter.spans.single;
      expect(span.kind, equals(SpanKind.client));
      expect(span.name, equals('url_launcher launch'));
      final attrs = _attrs(span);
      expect(attrs['url.full'], equals('https://example.com/page'));
      expect(attrs['url.scheme'], equals('https'));
      expect(attrs['url_launcher.operation'], equals('launch'));
    });

    test('exception flips span to Error', () async {
      await expectLater(
        tracedUrlLauncherCall<bool>(
          operation: 'launch',
          url: Uri.parse('bogus:'),
          invoke: () async => throw StateError('no app handles this scheme'),
        ),
        throwsStateError,
      );
      expect(exporter.spans.single.status, equals(SpanStatusCode.Error));
    });

    test('runWithoutUrlLauncherInstrumentationAsync bypasses spans', () async {
      await runWithoutUrlLauncherInstrumentationAsync(() async {
        await tracedUrlLauncherCall<bool>(
          operation: 'launch',
          url: Uri.parse('https://x/'),
          invoke: () async => true,
        );
      });
      expect(exporter.spans, isEmpty);
    });
  });
}
