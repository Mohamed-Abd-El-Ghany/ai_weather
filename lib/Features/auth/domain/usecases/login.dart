import '../../data/models/login_request.dart';
import '../repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<void> execute(LoginRequest loginRequest) async {
    await _repository.login(loginRequest);
  }
}