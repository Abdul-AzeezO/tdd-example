import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/utils/constants.dart';
import 'package:tdd_tutorial/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:tdd_tutorial/features/authentication/data/models/user_model.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthRemoteDataSourceImpl authRemoteDataSourceImpl;

  setUp(() {
    client = MockClient();
    authRemoteDataSourceImpl = AuthRemoteDataSourceImpl(client);
    registerFallbackValue(Uri());
  });

  group('AuthRemoteDataSourceImpl Tests', () {
    group('createUser', () {
      test(
        'should complete successfully if status code is 200 or 201',
        () async {
          when(() => client.post(any(), body: any(named: 'body'))).thenAnswer(
              (_) async => http.Response('user created successfully', 201));

          final methodCall = authRemoteDataSourceImpl.createUser;

          expect(
            methodCall(name: 'name', createdAt: 'createdAt', avatar: 'avatar'),
            completes,
          );

          verify(
            () => client.post(
              Uri.https(kBaseUrl, kCreateUserAndGetUsersEndPoint),
              body: jsonEncode({
                'name': 'name',
                'avatar': 'avatar',
                'createdAt': 'createdAt',
              }),
            ),
          ).called(1);
          verifyNoMoreInteractions(client);
        },
      );

      test(
        'should throw [APIException] if status code not 200 or 201',
        () async {
          when(() => client.post(any(), body: any(named: 'body'))).thenAnswer(
            (_) async => http.Response('Invalid Email Address', 400),
          );

          final methodCall = authRemoteDataSourceImpl.createUser;

          expect(
            () async => methodCall(
              name: 'name',
              createdAt: 'createdAt',
              avatar: 'avatar',
            ),
            throwsA(const APIException(
              message: 'Invalid Email Address',
              statusCode: 400,
            )),
          );

          verify(
            () => client.post(
              Uri.https(kBaseUrl, kCreateUserAndGetUsersEndPoint),
              body: jsonEncode({
                'name': 'name',
                'avatar': 'avatar',
                'createdAt': 'createdAt',
              }),
            ),
          ).called(1);
          verifyNoMoreInteractions(client);
        },
      );
    });

    group('getUsers', () {
      test(
        'should return [List<UserModel>] successfully if status code is 200',
        () async {
          final tUsers = List.generate(3, (index) => const UserModel.empty());
          when(() => client.get(any())).thenAnswer(
            (_) async => http.Response(
              jsonEncode(tUsers.map((e) => e.toMap()).toList()),
              200,
            ),
          );

          final result = await authRemoteDataSourceImpl.getUsers();
          expect(result, equals(tUsers));

          verify(
            () =>
                client.get(Uri.https(kBaseUrl, kCreateUserAndGetUsersEndPoint)),
          ).called(1);
          verifyNoMoreInteractions(client);
        },
      );

      test(
        'throw [APIException] when status code is not 200',
        () async {
          when(() => client.get(any())).thenAnswer(
            (_) async => http.Response('Internal Server Error', 500),
          );

          final methodCall = authRemoteDataSourceImpl.getUsers;
          expect(
            () => methodCall(),
            throwsA(
              const APIException(
                message: 'Internal Server Error',
                statusCode: 500,
              ),
            ),
          );

          verify(
            () =>
                client.get(Uri.https(kBaseUrl, kCreateUserAndGetUsersEndPoint)),
          ).called(1);
          verifyNoMoreInteractions(client);
        },
      );
    });
  });
}
