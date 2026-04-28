import 'package:aml_b2b_app/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the AML dashboard', (tester) async {
    await tester.pumpWidget(const AmlKontrollApp());

    expect(find.text('Operativ oversikt'), findsOneWidget);
    expect(find.text('Nordfjord Import AS'), findsWidgets);
    expect(find.text('AML-2048'), findsWidgets);
  });

  testWidgets('can move a case to escalated status', (tester) async {
    await tester.pumpWidget(const AmlKontrollApp());

    await tester.tap(find.text('Eskaler').first);
    await tester.pump();

    expect(find.text('Eskalert'), findsWidgets);
  });
}
