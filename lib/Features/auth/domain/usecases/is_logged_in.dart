import '../repository/auth_repository.dart';

class IsLoggedInUseCase {
  final AuthRepository _repository;

  IsLoggedInUseCase(this._repository);

  Future<bool> execute() async {
    return await _repository.isLoggedIn();
  }
}
