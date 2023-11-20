import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:tdd_tutorial/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:tdd_tutorial/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:tdd_tutorial/features/authentication/domain/repositories/auth_repository.dart';
import 'package:tdd_tutorial/features/authentication/domain/usecases/get_users.dart';
import 'package:tdd_tutorial/features/authentication/presentation/cubit/authentication_cubit.dart';

import '../../features/authentication/domain/usecases/create_user.dart';

final locator = GetIt.instance;

Future<void> init() async {
  //App Logic
  locator
    ..registerFactory(
      () => AuthenticationCubit(createUser: locator(), getUsers: locator()),
    )
    //Usecases
    ..registerLazySingleton(() => CreateUser(locator()))
    ..registerLazySingleton(() => GetUsers(locator()))
    //Repositories
    ..registerLazySingleton<AuthenticationRepository>(
      () => AuthRepositoryImpl(locator()),
    )
    //Datasources
    ..registerLazySingleton<AuthenticationRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(locator()),
    )
    //External Dependencies
    ..registerLazySingleton(http.Client.new);
}
