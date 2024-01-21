import 'package:flutter_test/flutter_test.dart';
import 'package:tedarik/services/Auth.dart';

void main() {
  group('AuthService Tests', () {
    test('AuthStateChanges Stream Test', () async {
      final authService = AuthService();

      final user = await authService.user.first;

      // Initially, the user should be null
      expect(user, null);

      // Perform authentication (you need to implement your authentication logic)
      // For example, authService.signInWithEmailAndPassword(email, password);

      // Wait for the stream to emit the new user
      final newUser = await authService.user.first;

      // Verify that the user is not null after authentication
      expect(newUser, isNotNull);
    });
  });
}
