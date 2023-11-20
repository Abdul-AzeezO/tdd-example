import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/features/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/features/authentication/domain/usecases/create_user.dart';
import 'package:tdd_tutorial/features/authentication/domain/usecases/get_users.dart';
import 'package:tdd_tutorial/features/authentication/presentation/cubit/authentication_cubit.dart';

class MockCreateUser extends Mock implements CreateUser {}

class MockGetUsers extends Mock implements GetUsers {}

void main() {
  late GetUsers getUsers;
  late CreateUser createUser;
  late AuthenticationCubit authCubit;
  final tCreateUserParams = CreateUserParams.empty();
  const tApiFailure = APIFailure(message: 'message', statusCode: 400);
  final tUsers = List.generate(3, (index) => const User.empty());

  setUp(() {
    getUsers = MockGetUsers();
    createUser = MockCreateUser();
    authCubit = AuthenticationCubit(createUser: createUser, getUsers: getUsers);
    registerFallbackValue(tCreateUserParams);
  });

  tearDown(() => authCubit.close());

  group('Authentication Cubic Tests', () {
    test('initial state should be [AuthenticationInitial]', () async {
      expect(authCubit.state, const AuthenticationInitial());
    });

    group('createUser', () {
      blocTest<AuthenticationCubit, AuthenticationState>(
        'should emit [CreatingUser, UserCreated] when Successful',
        build: () {
          when(() => createUser(any()))
              .thenAnswer((_) async => const Right(null));
          return authCubit;
        },
        act: (cubit) {
          //if bloc, bloc.addEvent();
          cubit.createUser(
            name: tCreateUserParams.name,
            avatar: tCreateUserParams.avatar,
            createdAt: tCreateUserParams.createdAt,
          );
        },
        expect: () => const [CreatingUser(), UserCreated()],
        verify: (_) {
          verify(() => createUser(tCreateUserParams)).called(1);
          verifyNoMoreInteractions(createUser);
        },
      );

      blocTest<AuthenticationCubit, AuthenticationState>(
        'should emit [CreatingUser, AuthenticationError] when unsuccessful',
        build: () {
          when(() => createUser(any()))
              .thenAnswer((_) async => const Left(tApiFailure));
          return authCubit;
        },
        act: (cubit) {
          //if bloc, bloc.addEvent();
          cubit.createUser(
            name: tCreateUserParams.name,
            avatar: tCreateUserParams.avatar,
            createdAt: tCreateUserParams.createdAt,
          );
        },
        expect: () => [
          const CreatingUser(),
          AuthenticationError(tApiFailure.errorMessage),
        ],
        verify: (_) {
          verify(() => createUser(tCreateUserParams)).called(1);
          verifyNoMoreInteractions(createUser);
        },
      );
    });

    group('getUsers', () {
      blocTest<AuthenticationCubit, AuthenticationState>(
        'should emit [GettingUsers, UserLoaded] when Successful',
        build: () {
          when(() => getUsers()).thenAnswer((_) async => Right(tUsers));
          return authCubit;
        },
        act: (cubit) => cubit.getUsers(),
        expect: () => [const GettingUsers(), UsersLoaded(tUsers)],
        verify: (_) {
          verify(() => getUsers()).called(1);
          verifyNoMoreInteractions(getUsers);
        },
      );

      blocTest<AuthenticationCubit, AuthenticationState>(
        'should emit [CreatingUser, AuthenticationError] when unsuccessful',
        build: () {
          when(() => getUsers())
              .thenAnswer((_) async => const Left(tApiFailure));
          return authCubit;
        },
        act: (cubit) => cubit.getUsers(),
        expect: () => [
          const GettingUsers(),
          AuthenticationError(tApiFailure.errorMessage),
        ],
        verify: (_) {
          verify(() => getUsers()).called(1);
          verifyNoMoreInteractions(getUsers);
        },
      );
    });
  });
}
