import 'package:jaspr/client.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:namma_kahoot_jaspr/components/app.dart';

void main() {
  runApp(
    ProviderScope(
      child: App(),
    ),
  );
}
