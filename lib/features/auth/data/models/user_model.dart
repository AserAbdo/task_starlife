import 'package:equatable/equatable.dart';

/// User model for authentication
class UserModel extends Equatable {
  final int? id;
  final String email;
  final String? token;

  const UserModel({this.id, required this.email, this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      email: json['email'] as String? ?? '',
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'token': token};
  }

  @override
  List<Object?> get props => [id, email, token];
}
