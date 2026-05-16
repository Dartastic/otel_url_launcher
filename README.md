# otel_url_launcher

OpenTelemetry instrumentation for
[`package:url_launcher`](https://pub.dev/packages/url_launcher).

```dart
import 'package:otel_url_launcher/otel_url_launcher.dart';

await tracedLaunchUrl(Uri.parse('https://example.com'));
final ok = await tracedCanLaunchUrl(Uri.parse('mailto:hi@example.com'));
```

Each call opens a CLIENT span:
- name: `url_launcher launch` / `url_launcher can_launch`
- `url.full = <full URL>`
- `url.scheme = <scheme>` (e.g. `https`, `mailto`, `tel`)
- `url_launcher.operation = launch` or `can_launch`

Useful for tracing deep-link follow-throughs and external-app
launches as part of a user journey.

Suppression: `runWithoutUrlLauncherInstrumentationAsync`.

## License

Apache 2.0
