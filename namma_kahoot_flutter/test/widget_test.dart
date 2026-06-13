import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namma_kahoot_flutter/main.dart';

void main() {
  testWidgets('Kahoot Home Screen loads and shows action buttons', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Verify that our app shows the home screen widgets.
    expect(find.text('Namma Kahoot'), findsOneWidget);
    expect(find.text('Join Game (Player)'), findsOneWidget);
    expect(find.text('Host a Game'), findsOneWidget);
    expect(find.text('Admin (Create Quiz)'), findsOneWidget);
  });
}
