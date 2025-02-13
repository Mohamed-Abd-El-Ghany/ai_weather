import '../../domain/repository/auth_repository.dart';
import '../data_source/auth_firebase_service.dart';
import '../models/forget_password_request.dart';
import '../models/login_request.dart';
import '../models/signup_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthFirebaseService _authService;

  AuthRepositoryImpl(this._authService);

  @override
  Future<void> login(LoginRequest loginRequest) async {
    await _authService.login(loginRequest);
  }

  @override
  Future<void> signup(SignupRequest signupRequest) async {
    await _authService.signup(signupRequest);
  }

  @override
  Future<void> forgetPassword(ForgetPasswordRequest forgetPasswordRequest) async {
    await _authService.forgetPassword(forgetPasswordRequest);
  }

  @override
  Future<bool> isLoggedIn() async{
     return await _authService.isLoggedIn();
  }

  @override
  Future<void> logout() async{
    return await _authService.logout();
  }
}
