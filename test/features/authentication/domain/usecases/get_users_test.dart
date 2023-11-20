import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/features/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/features/authentication/domain/repositories/auth_repository.dart';
import 'package:tdd_tutorial/features/authentication/domain/usecases/get_users.dart';

import '../../../../../test/features/authentication/domain/usecases/auth_repository.mock.dart';

void main() {
  late GetUsers useCase;
  late AuthenticationRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    useCase = GetUsers(repository);
  });

  final emptyUsers = List.generate(3, (index) => const User.empty());
  test(
    'should call [AuthRepo.getUsers]',
    () async {
      //Arrange
      //Stub
      when(() => repository.getUsers())
          .thenAnswer((_) async => Right(emptyUsers));

      //Act
      final result = await useCase();

      //Assert
      expect(result, Right(emptyUsers));
      verify(() => repository.getUsers()).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
