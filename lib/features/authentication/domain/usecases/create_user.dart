import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typdefs.dart';

import '../repositories/auth_repository.dart';

class CreateUser extends UsecaseWithParams<void, CreateUserParams> {
  const CreateUser(this._repository);

  final AuthenticationRepository _repository;

  @override
  ResultVoid call(CreateUserParams params) async =>
      await _repository.createUser(
        createdAt: params.createdAt,
        name: params.name,
        avatar: params.avatar,
      );
}

class CreateUserParams extends Equatable {
  const CreateUserParams({
    required this.name,
    required this.avatar,
    required this.createdAt,
  });

  factory CreateUserParams.empty() => const CreateUserParams(
        name: '',
        avatar: '',
        createdAt: '',
      );

  final String name;
  final String avatar;
  final String createdAt;

  @override
  List<Object?> get props => [name, avatar, createdAt];
}
