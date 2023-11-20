import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_tutorial/core/utils/typdefs.dart';
import 'package:tdd_tutorial/features/authentication/data/models/user_model.dart';
import 'package:tdd_tutorial/features/authentication/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tModel = UserModel.empty();
  final tJson = fixture('user.json');
  final tMap = jsonDecode(tJson) as DataMap;

  group('UserModel Tests', () {
    test(
      'should be a subclass of [User] entity',
      () => expect(tModel, isA<User>()),
    );

    test('fromMap should return a [UserModel] equal to defined model', () {
      //Act
      final result = UserModel.fromMap(tMap);
      //Assert
      expect(result, equals(tModel));
    });

    test('fromJson should return a [UserModel] with the right data', () {
      //Act
      final result = UserModel.fromJson(tJson);
      //Assert
      expect(result, equals(tModel));
    });

    test('toMap should return a [DataMap] with the right data', () {
      final result = tModel.toMap();
      expect(result, equals(tMap));
    });

    test('toJson return a [JSON String] with the right data', () {
      final result = tModel.toJson();
      final newJson = jsonEncode({
        "id": "1",
        "name": "empty",
        "avatar": "empty",
        "createdAt": "empty"
      });
      expect(result, equals(newJson));
    });

    test('copyWith return a [UserModel] with  different data', () {
      final newUser = tModel.copyWith(id: '2');
      expect(newUser.id, equals('2'));
      expect(newUser, isNot(equals(tModel)));
    });
  });
}
