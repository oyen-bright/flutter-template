import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{package}}/shared/ui/ui.dart';

void main() {
  testWidgets('App{{name.pascalCase()}} renders', (tester) async {
    await tester.pumpWidget(
      const ShadApp(home: Scaffold(body: App{{name.pascalCase()}}())),
    );
    expect(find.byType(App{{name.pascalCase()}}), findsOneWidget);
  });
}
