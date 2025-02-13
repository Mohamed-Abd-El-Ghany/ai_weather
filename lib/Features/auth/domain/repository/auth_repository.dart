import '../../data/models/forget_password_request.dart';
import '../../data/models/login_request.dart';
import '../../data/models/signup_request.dart';

abstract class AuthRepository {
  Future<void> login(LoginRequest loginRequest);
  Future<void> signup(SignupRequest signupRequest);
  Future<void> forgetPassword(ForgetPasswordRequest forgetPasswordRequest);
  Future<bool> isLoggedIn();
  Future<void> logout();
}
