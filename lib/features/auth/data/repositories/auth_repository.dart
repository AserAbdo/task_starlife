import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

/// Repository for authentication operations
class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  /// Login with email and password
  /// Uses reqres.in test API
  Future<UserModel> login({
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
      rethrow;
    }
  }
}
