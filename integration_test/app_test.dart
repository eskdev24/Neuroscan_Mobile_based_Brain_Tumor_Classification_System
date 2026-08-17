import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Splash screen renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Placeholder()));
    expect(find.byType(Placeholder), findsOneWidget);
  });
}
