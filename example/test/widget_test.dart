import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

void main() {
  testWidgets('home renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Home()));
    expect(find.text('휴대폰 인증'), findsOneWidget);
  });
}
