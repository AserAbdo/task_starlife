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
    } on AuthException catch (e) {
      emit(LoginError(message: e.message));
    } catch (e) {
      emit(
        LoginError(message: 'An unexpected error occurred. Please try again.'),
      );
    }
  }

  /// Reset state to initial
  void reset() {
    emit(const LoginInitial());
  }
}
