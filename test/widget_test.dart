import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('add', () {
    testWidgets('Show result when two inputs are given',
        (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorClass());

      final topTextFieldFinder = find.byKey(const Key('textfield_top_plus'));
      final bottomTextFieldFinder =
          find.byKey(const Key('textfield_bottom_plus'));
      final resultFinder = find.byKey(const Key('button_plus'));

      await tester.ensureVisible(topTextFieldFinder);
      await tester.tap(topTextFieldFinder);
      await tester.enterText(topTextFieldFinder, '3');

      await tester.ensureVisible(bottomTextFieldFinder);
      await tester.tap(bottomTextFieldFinder);
      await tester.enterText(bottomTextFieldFinder, '6');

      await tester.tap(resultFinder);

      await tester.pumpAndSettle();
      expect(find.text('Result: 9.0'), findsOneWidget);
    });
  });
}

class CalculatorClass extends StatefulWidget {
  const CalculatorClass({key}) : super(key: key);

  @override
  State<CalculatorClass> createState() => _CalculatorClassState();
}

class _CalculatorClassState extends State<CalculatorClass> {
  TextEditingController param1 = TextEditingController();
  TextEditingController param2 = TextEditingController();
  int res = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [
            TextFormField(
              key: const Key('textfield_top_plus'),
              controller: param1,
            ),
            TextFormField(
              key: const Key('textfield_bottom_plus'),
              controller: param2,
            ),
            ElevatedButton(
              key: const Key('button_plus'),
              onPressed: () {
                setState(() {
                  res = int.parse(param1.text) + int.parse(param2.text);
                });
              },
              child: const Text('Add up'),
            ),
            Text('Result: $res.0', key: const Key('result_plus')),
          ],
        ),
      ),
    );
  }
}