import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:scholer_plan_app/main.dart';

void main() {
  testWidgets('Scholarplan app navigation smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify WelcomeScreen elements exist
    expect(find.text('Welcome!'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    // Tap 'Get Started' and navigate to SignUpScreen
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    // Verify SignUpScreen elements exist
    expect(find.text('Sign up for Scholarplan:'), findsOneWidget);
    expect(find.text('Continue with Email'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
  });
}
