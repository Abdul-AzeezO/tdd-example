import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typdefs.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetUsers extends UsecaseWithoutParams<List<User>> {
  const GetUsers(this._repository);

  final AuthenticationRepository _repository;

  @override
  ResultFuture<List<User>> call() async => await _repository.getUsers();
}
