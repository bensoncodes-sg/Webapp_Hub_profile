// Smoke test: the card renders Benson's name and the key actions.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:benson_nfc_card/main.dart';

void main() {
  testWidgets('Card renders name and primary actions', (WidgetTester tester) async {
    await tester.pumpWidget(const NfcCardApp());
    await tester.pump();

    expect(find.text('Benson Phuah'), findsOneWidget);
    expect(find.text('Save to contacts'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('WhatsApp'), findsOneWidget);
  });
}
