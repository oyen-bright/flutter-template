import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}/shared/ui/ui.dart';

void main() {
  Widget host(Widget child) => ShadApp(home: Scaffold(body: child));

  testWidgets('AppButton calls onPressed', (tester) async {
    var taps = 0;
    await tester.pumpWidget(host(AppButton(label: 'Pay', onPressed: () => taps++)));
    await tester.tap(find.text('Pay'));
    expect(taps, 1);
  });

  testWidgets('AppButton ignores taps while loading', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      host(AppButton(label: 'Pay', isLoading: true, onPressed: () => taps++)),
    );
    await tester.tap(find.text('Pay'), warnIfMissed: false);
    expect(taps, 0);
  });
}
