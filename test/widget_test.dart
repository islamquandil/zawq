import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zawq/main.dart';

void main() {
  testWidgets('boots to splash, then shows the four-tab shell',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ZawqApp()));

    // Splash wordmark is visible first.
    expect(find.text('ذوق'), findsOneWidget);

    // Let the splash timer elapse and the fade complete.
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();

    // The navigation shell is present with its four destinations.
    expect(find.text('Map'), findsWidgets);
    expect(find.text('People'), findsWidgets);
    expect(find.text('Lists'), findsWidgets);
    expect(find.text('Profile'), findsWidgets);
  });
}
