import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tdd_tutorial/core/errors/exceptions.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/utils/typdefs.dart';
import '../models/user_model.dart';

abstract class AuthenticationRemoteDataSource {
  Future<void> createUser({
    required String name,
    required String createdAt,
    required String avatar,
  });

  // return the model not the entities in datasource
  Future<List<UserModel>> getUsers();
}

const kCreateUserAndGetUsersEndPoint = '/test-api/users';

class AuthRemoteDataSourceImpl implements AuthenticationRemoteDataSource {
  AuthRemoteDataSourceImpl(this._client);

  final http.Client _client;

  @override
  Future<void> createUser({
    required String name,
    required String createdAt,
    required String avatar,
  }) async {
    try {
      final response = await _client.post(
        Uri.https(kBaseUrl, kCreateUserAndGetUsersEndPoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'avatar': avatar,
          'createdAt': createdAt,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw const APIException(
          message: 'Invalid Email Address',
          statusCode: 400,
        );
      }
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _client
          .get(Uri.https(kBaseUrl, kCreateUserAndGetUsersEndPoint));

      if (response.statusCode != 200) {
        throw APIException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }

      return List<DataMap>.from(jsonDecode(response.body) as List)
          .map((userData) => UserModel.fromMap(userData))
          .toList();
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }
}
