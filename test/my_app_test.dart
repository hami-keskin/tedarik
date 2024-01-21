import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tedarik/main.dart';
import 'package:tedarik/models/FirebaseUser.dart';
import 'package:tedarik/screens/wrapper.dart';

void main() {
  group('MyApp Widget Tests', () {
    testWidgets('Renders MyApp Widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MyApp(),
        ),
      );

      // Verify that MyApp is rendered
      expect(find.byType(MyApp), findsOneWidget);
    });

    testWidgets('Renders Wrapper Widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MyApp(),
        ),
      );

      // Verify that Wrapper is rendered inside MyApp
      expect(find.byType(Wrapper), findsOneWidget);
    });

    testWidgets('Renders Wrapper Widget with Authenticated User', (WidgetTester tester) async {
      // Create a fake user for testing
      final fakeUser = FirebaseUser(uid: 'fake_uid');

      await tester.pumpWidget(
        MaterialApp(
          home: StreamProvider<FirebaseUser?>.value(
            value: Stream.value(fakeUser),
            initialData: null,
            child: MyApp(),
          ),
        ),
      );

      // Verify that Wrapper is rendered with an authenticated user
      expect(find.byType(Wrapper), findsOneWidget);
    });
  });
}
