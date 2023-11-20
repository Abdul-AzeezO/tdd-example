import 'dart:convert';

import '../../../../core/utils/typdefs.dart';
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.createdAt,
    required super.name,
    required super.avatar,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? avatar,
    String? createdAt,
  }) =>
      UserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
        createdAt: createdAt ?? this.createdAt,
      );

  const UserModel.empty()
      : this(id: '1', name: 'empty', avatar: 'empty', createdAt: 'empty');

  UserModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          name: map['name'] as String,
          avatar: map['avatar'] as String,
          createdAt: map['createdAt'] as String,
        );

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as DataMap);

  DataMap toMap() =>
      {'id': id, 'name': name, 'avatar': avatar, 'createdAt': createdAt};

  String toJson() => jsonEncode(toMap());
}
