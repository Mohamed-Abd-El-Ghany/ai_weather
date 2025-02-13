import '../../data/models/signup_request.dart';
import '../repository/auth_repository.dart';

class SignupUseCase {
  final AuthRepository _repository;

  SignupUseCase(this._repository);

  Future<void> execute(SignupRequest signupRequest) async {
    await _repository.signup(signupRequest);
  }
}