import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:capture_box_example/main.dart';

void main() {
  testWidgets('Widget Exists', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(
      find.byWidgetPredicate(
        (Widget widget) => widget is Text 
        && (widget.data ?? "").startsWith("Example"),
      ),
      findsOneWidget,
    );
  });
}
