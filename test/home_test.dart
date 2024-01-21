import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tedarik/ViewSuppliesPage.dart';
import 'package:tedarik/ManageSuppliesPage.dart';
import 'package:tedarik/screens/help/HelpScreen.dart';
import 'package:tedarik/screens/home/home.dart';
import 'package:tedarik/services/Auth.dart';
import 'package:tedarik/CreateSupplyPage.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService authService;

  setUp(() {
    authService = MockAuthService();
  });

  group('Home Widget Tests', () {
    testWidgets('Renders Home widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Home(),
        ),
      );

      expect(find.byType(Home), findsOneWidget);
    });

    testWidgets('Taps on "Tedarik Oluştur" button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Home(),
        ),
      );

      await tester.tap(find.text('Tedarik Oluştur'));
      await tester.pumpAndSettle();

      expect(find.byType(CreateSupplyPage), findsOneWidget);
    });

    testWidgets('Taps on "Tedarik Yönetimi" button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Home(),
        ),
      );

      await tester.tap(find.text('Tedarik Yönetimi'));
      await tester.pumpAndSettle();

      expect(find.byType(ManageSuppliesPage), findsOneWidget);
    });

    testWidgets('Taps on "Tedarik Listesi" button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Home(),
        ),
      );

      await tester.tap(find.text('Tedarik Listesi'));
      await tester.pumpAndSettle();

      expect(find.byType(ViewSuppliesPage), findsOneWidget);
    });

    testWidgets('Taps on "Yardım" button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Home(),
        ),
      );

      await tester.tap(find.text('Yardım'));
      await tester.pumpAndSettle();

      expect(find.byType(HelpScreen), findsOneWidget);
    });

    testWidgets('Taps on "Çıkış" button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Home(),
        ),
      );

      await tester.tap(find.text('Çıkış'));
      await tester.pumpAndSettle();

      // You can use Mockito to verify that the signOut method is called
      verify(authService.signOut()).called(1);
    });
  });
}
