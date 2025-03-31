import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Test accessibility', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ElevatedButton(
          onPressed: () {},
          child: const Text('Submit'),
        ),
      ),
    ));

    // Test that the button has the correct semantics
    expect(find.text('Submit'), findsOneWidget);
    expect(find.bySemanticsLabel('Submit Button'), findsOneWidget);
  });
}
