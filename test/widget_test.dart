import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:scholer_plan_app/main.dart';
import 'package:scholer_plan_app/screens/home_screen.dart';

void main() {
  testWidgets('Full CRUD (Create, Read, Update, Delete) verification test', (WidgetTester tester) async {
    // Build HomeScreen widget directly
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. CREATE: Enter task in TextField and tap 'Add Task'
    final textFieldFinder = find.byType(TextField).first;
    await tester.enterText(textFieldFinder, 'Buy groceries');
    await tester.tap(find.text('Add Task'));
    await tester.pumpAndSettle();

    // 2. READ: Verify item is displayed dynamically in ListView
    expect(find.text('Buy groceries'), findsOneWidget);

    // 3. UPDATE: Tap Edit button, update text in AlertDialog, tap Save
    await tester.tap(find.byIcon(Icons.edit).first);
    await tester.pumpAndSettle();

    final editTextFieldFinder = find.byType(TextField).last;
    await tester.enterText(editTextFieldFinder, 'Buy organic groceries');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Verify updated text is displayed
    expect(find.text('Buy organic groceries'), findsOneWidget);
    expect(find.text('Buy groceries'), findsNothing);

    // 4. DELETE: Tap Delete button, verify item is removed using removeAt(index)
    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pumpAndSettle();

    // Verify item is removed
    expect(find.text('Buy organic groceries'), findsNothing);
  });
}
