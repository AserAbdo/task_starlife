import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import 'login_state.dart';

/// Cubit for managing login state
class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit({AuthRepository? authRepository})
    : _authRepository = authRepository ?? AuthRepository(),
      super(const LoginInitial());

  /// Attempt to login with email and password
  Future<void> login({required String email, required String password}) async {
    emit(const LoginLoading());

    try {
      final user = await _authRepository.login(
        email: email,
        password: password,
      );

      emit(LoginSuccess(user: user));
    } on DioException catch (e) {
      String errorMessage = 'An error occurred. Please try again.';

      if (e.response != null) {
        final data = e.response?.data;
        if (data is Map<String, dynamic> && data.containsKey('error')) {
          errorMessage = data['error'] as String;
        } else if (e.response?.statusCode == 400) {
          errorMessage = 'Invalid email or password';
        } else if (e.response?.statusCode == 401) {
          errorMessage = 'Unauthorized. Please check your credentials.';
        }
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Connection timeout. Please check your internet.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection.';
      }

      emit(LoginError(message: errorMessage));
    } catch (e) {
      emit(LoginError(message: 'An unexpected error occurred: $e'));
    }
  }

  /// Reset state to initial
  void reset() {
    emit(const LoginInitial());
  }
}
