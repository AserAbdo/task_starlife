import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

/// Repository for authentication operations
class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  /// Login with email and password
  /// Uses mock authentication for testing
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // Test credentials for demo
    // You can use any of these:
    // 1. test@starlife.com / password123
    // 2. admin@starlife.com / admin123
    // 3. demo@demo.com / demo123
    // 4. eve.holt@reqres.in / cityslicka (original)

    final validCredentials = {
      'test@starlife.com': 'password123',
      'admin@starlife.com': 'admin123',
      'demo@demo.com': 'demo123',
      'eve.holt@reqres.in': 'cityslicka',
      'user@example.com': '123456',
    };

    // Check if email exists and password matches
    if (validCredentials.containsKey(email.toLowerCase())) {
      if (validCredentials[email.toLowerCase()] == password) {
        // Success - return user with mock token
        return UserModel(
          id: 1,
          email: email,
          token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        );
      } else {
        // Wrong password
        throw AuthException('Invalid password. Please try again.');
      }
    } else {
      // Email not found - but for demo, let's accept any valid email format
      // with password >= 6 chars
      if (_isValidEmail(email) && password.length >= 6) {
        return UserModel(
          id: 2,
          email: email,
          token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        );
      }
      throw AuthException('User not found. Please check your email.');
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  /// Try to login with real API (reqres.in)
  /// Falls back to mock if API fails
  Future<UserModel> loginWithApi({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      final data = response.data as Map<String, dynamic>;

      return UserModel(email: email, token: data['token'] as String?);
    } catch (e) {
      // If API fails, use mock login
      return login(email: email, password: password);
    }
  }
}

/// Custom exception for authentication errors
class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => message;
}
