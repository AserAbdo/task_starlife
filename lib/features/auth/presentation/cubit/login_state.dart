import 'package:equatable/equatable.dart';
import '../../data/models/user_model.dart';

/// Authentication states for the LoginCubit
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class LoginInitial extends LoginState {
  const LoginInitial();
}

/// Loading state during API call
class LoginLoading extends LoginState {
  const LoginLoading();
}

/// Success state after successful login
class LoginSuccess extends LoginState {
  final UserModel user;

  const LoginSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Error state when login fails
class LoginError extends LoginState {
  final String message;

  const LoginError({required this.message});

  @override
  List<Object?> get props => [message];
}
