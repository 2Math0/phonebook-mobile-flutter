// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:conca/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('basic test', () {
    testWidgets('App Initialize', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());
      // make sure it went to log In with no errors
      expect(find.text('LOG IN'), findsNWidgets(2));

      await tester.pumpAndSettle();
    });
  });
}
