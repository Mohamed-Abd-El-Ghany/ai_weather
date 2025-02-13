import '../../data/models/forget_password_request.dart';
import '../repository/auth_repository.dart';

class ForgetPasswordUseCase {
  final AuthRepository _repository;

  ForgetPasswordUseCase(this._repository);

  Future<void> execute(ForgetPasswordRequest forgetPasswordRequest) async {
    await _repository.forgetPassword(forgetPasswordRequest);
  }
}