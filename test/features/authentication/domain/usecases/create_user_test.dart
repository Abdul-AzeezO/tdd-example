import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/features/authentication/domain/repositories/auth_repository.dart';
import 'package:tdd_tutorial/features/authentication/domain/usecases/create_user.dart';

import '../../../../../test/features/authentication/domain/usecases/auth_repository.mock.dart';

void main() {
  late CreateUser useCase;
  late AuthenticationRepository repository;
  setUp(() {
    repository = MockAuthRepository();
    useCase = CreateUser(repository);
  });

  final params = CreateUserParams.empty();

  test(
    'should call the [AuthRepo.createUser]',
    () async {
      //Arrange
      //Stub
      when(
        () => repository.createUser(
          createdAt: any(named: 'createdAt'),
          name: any(named: 'name'),
          avatar: any(named: 'avatar'),
        ),
      ).thenAnswer((_) async => const Right(null));
      //Act
      final result = await useCase(params);
      //Assert
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => repository.createUser(
          createdAt: params.createdAt,
          name: params.name,
          avatar: params.avatar,
        ),
      ).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
