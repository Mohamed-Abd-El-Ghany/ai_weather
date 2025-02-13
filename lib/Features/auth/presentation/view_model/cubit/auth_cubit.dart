import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/forget_password_request.dart';
import '../../../data/models/login_request.dart';
import '../../../data/models/signup_request.dart';
import '../../../domain/usecases/forget_password.dart';
import '../../../domain/usecases/login.dart';
import '../../../domain/usecases/signup.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final ForgetPasswordUseCase forgetPasswordUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.forgetPasswordUseCase,
  }) : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);

  Future<void> login(LoginRequest loginRequest) async {
    emit(AuthLoading());
    try {
      await loginUseCase.execute(loginRequest);
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(_getFirebaseErrorMessage(e)));
    } catch (e) {
      emit(AuthFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> signup(SignupRequest signupRequest) async {
    emit(AuthLoading());
    try {
      await signupUseCase.execute(signupRequest);
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(_getFirebaseErrorMessage(e)));
    } catch (e) {
      emit(AuthFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> forgetPassword(ForgetPasswordRequest forgetPasswordRequest) async {
    emit(AuthLoading());
    try {
      await forgetPasswordUseCase.execute(forgetPasswordRequest);
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(_getFirebaseErrorMessage(e)));
    } catch (e) {
      emit(AuthFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is invalid';
      case 'user-disabled':
        return 'This user has been disabled';
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'The email address is already in use';
      case 'operation-not-allowed':
        return 'This operation is not allowed';
      case 'weak-password':
        return 'The password is too weak';
      case 'network-request-failed':
        return 'Network request failed';
      default:
        return 'An unexpected error occurred: ${e.message}';
    }
  }
}