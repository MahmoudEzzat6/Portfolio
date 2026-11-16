import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/main.dart';

void main() {
  testWidgets('PortfolioApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PortfolioApp());
    // Advance time past the entrance stagger delays
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('MAHMOUD '), findsOneWidget);
    expect(find.text('EZZAT'), findsOneWidget);

    // Dispose tree cleanly
    await tester.pumpWidget(const SizedBox());
  });
}
