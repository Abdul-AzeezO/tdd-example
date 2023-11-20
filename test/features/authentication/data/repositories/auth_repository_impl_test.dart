import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:tdd_tutorial/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:tdd_tutorial/features/authentication/domain/entities/user.dart';

class MockAuthRemoteDataSource extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource remoteDataSource;
  late AuthRepositoryImpl authRepositoryImpl;
  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    authRepositoryImpl = AuthRepositoryImpl(remoteDataSource);
  });

  const name = 'whatever.name';
  const avatar = 'whatever.name';
  const createdAt = 'whatever.createdAt';

  const tException =
      APIException(message: 'Internal Server Error', statusCode: 500);

  group('createUser', () {
    test(
      'should call [RemoteDataSource.createUser] and return void when the future completes',
      () async {
        //Arrange
        when(
          () => remoteDataSource.createUser(
            name: any(named: 'name'),
            createdAt: any(named: 'createdAt'),
            avatar: any(named: 'avatar'),
          ),
        ).thenAnswer((_) async => Future.value());

        //Act
        final result = await authRepositoryImpl.createUser(
          createdAt: createdAt,
          name: name,
          avatar: avatar,
        );
        expect(result, equals(const Right(null)));

        //Assert
        verify(() => remoteDataSource.createUser(
              name: name,
              createdAt: createdAt,
              avatar: avatar,
            )).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return a [ServerFailure] if [RemoteDataSource.createUser] fails',
      () async {
        when(
          () => remoteDataSource.createUser(
            name: any(named: 'name'),
            createdAt: any(named: 'createdAt'),
            avatar: any(named: 'avatar'),
          ),
        ).thenThrow(tException);

        final result = await authRepositoryImpl.createUser(
          createdAt: createdAt,
          name: name,
          avatar: avatar,
        );
        expect(result, equals(Left(APIFailure.fromException(tException))));

        verify(() => remoteDataSource.createUser(
              name: name,
              createdAt: createdAt,
              avatar: avatar,
            )).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });
  group('getUsers', () {
    test(
      'should call [RemoteDataSource.getUsers] and return List<UserModel> if future is successful',
      () async {
        when(() => remoteDataSource.getUsers()).thenAnswer((_) async => []);

        final result = await authRepositoryImpl.getUsers();
        expect(result, isA<Right<dynamic, List<User>>>());

        verify(() => remoteDataSource.getUsers()).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return [ServerFailure] if [RemoteDataSource.getUser] fails',
      () async {
        when(() => remoteDataSource.getUsers()).thenThrow(tException);
        final result = await authRepositoryImpl.getUsers();
        expect(result, Left(APIFailure.fromException(tException)));
        verify(() => remoteDataSource.getUsers()).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });
}
