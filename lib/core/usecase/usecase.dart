import 'package:tdd_tutorial/core/utils/typdefs.dart';

abstract class UsecaseWithParams<Type, Param> {
  const UsecaseWithParams();
  ResultFuture<Type> call(Param params);
}

abstract class UsecaseWithoutParams<Type> {
  const UsecaseWithoutParams();
  ResultFuture<Type> call();
}
