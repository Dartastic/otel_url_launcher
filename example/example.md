# otel_url_launcher example

```dart
// example/lib/main.dart

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:flutter/material.dart';
import 'package:otel_url_launcher/otel_url_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> main() async {
  // 1. Bring up OTel before runApp so trace context is already
  //    flowing when the first launch happens.
  await OTel.initialize(
    serviceName: 'url-launcher-demo',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _openDocs() async {
    final url = Uri.parse('https://opentelemetry.io/docs/');

    // ✨ Span: `url_launcher can_launch` (CLIENT)
    //    Attrs: url.full, url.scheme, url_launcher.operation=can_launch
    if (await tracedCanLaunchUrl(url)) {
      // ✨ Span: `url_launcher launch` (CLIENT)
      //    Attrs: url.full, url.scheme, url_launcher.operation=launch
      //    Errors: recorded as span exception + status Error.
      await tracedLaunchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openQuietly() async {
    // Suppress instrumentation for a flow you don't want traced.
    await runWithoutUrlLauncherInstrumentationAsync(() async {
      await tracedLaunchUrl(Uri.parse('https://example.com/'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _openDocs,
              child: const Text('Open the OpenTelemetry docs'),
            ),
            ElevatedButton(
              onPressed: _openQuietly,
              child: const Text('Open without spans'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Trace shape

```
tap "Open the OpenTelemetry docs"
  url_launcher can_launch        url.full=https://opentelemetry.io/docs/
  url_launcher launch            url.scheme=https

(failure: no app handles the scheme)
  url_launcher launch            status=Error, exception recorded
```
