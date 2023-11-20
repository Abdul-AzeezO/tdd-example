part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class CreateUserEvent extends AuthenticationEvent {
  const CreateUserEvent({
    required this.name,
    required this.avatar,
    required this.createdAt,
  });

  final String name;
  final String avatar;
  final String createdAt;

  @override
  List<Object?> get props => [name, avatar, createdAt];
}

class GetUsersEvent extends AuthenticationEvent {
  const GetUsersEvent();
}
