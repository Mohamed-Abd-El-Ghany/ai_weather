import 'package:ai_weather/Features/auth/data/models/forget_password_request.dart';
import 'package:ai_weather/Features/auth/data/models/login_request.dart';
import 'package:ai_weather/Features/auth/data/models/signup_request.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ai_weather/Features/auth/domain/usecases/login.dart';
import 'package:ai_weather/Features/auth/domain/usecases/signup.dart';
import 'package:ai_weather/Features/auth/domain/usecases/forget_password.dart';
import 'package:ai_weather/Features/auth/presentation/view_model/cubit/auth_cubit.dart';
import 'package:ai_weather/Features/auth/presentation/view_model/cubit/auth_states.dart';

// Mock Use Cases
class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockSignupUseCase extends Mock implements SignupUseCase {}

class MockForgetPasswordUseCase extends Mock implements ForgetPasswordUseCase {}

void main() {
  late AuthCubit authCubit;
  late MockLoginUseCase mockLoginUseCase;
  late MockSignupUseCase mockSignupUseCase;
  late MockForgetPasswordUseCase mockForgetPasswordUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockSignupUseCase = MockSignupUseCase();
    mockForgetPasswordUseCase = MockForgetPasswordUseCase();

    authCubit = AuthCubit(
      loginUseCase: mockLoginUseCase,
      signupUseCase: mockSignupUseCase,
      forgetPasswordUseCase: mockForgetPasswordUseCase,
    );
  });

  tearDown(() {
    authCubit.close();
  });

  final loginRequest = LoginRequest(email: 'test@example.com', password: 'password');
  final signupRequest = SignupRequest(
    name: 'Test',
    phone: '123456789',
    email: 'test@example.com',
    password: 'password',
  );
  final forgetPasswordRequest = ForgetPasswordRequest(email: 'test@example.com');

  // Test Login Event
  blocTest<AuthCubit, AuthState>(
    'emits [AuthLoading, AuthSuccess] when login is successful',
    setUp: () {
      when(mockLoginUseCase.execute(loginRequest)).thenAnswer((_) async => Future.value());
    },
    build: () => authCubit,
    act: (cubit) => cubit.login(loginRequest),
    expect: () => [AuthLoading(), AuthSuccess()],
  );

  blocTest<AuthCubit, AuthState>(
    'emits [AuthLoading, AuthFailure] when login fails',
    setUp: () {
      when(mockLoginUseCase.execute(loginRequest)).thenThrow(Exception('Login failed'));
    },
    build: () => authCubit,
    act: (cubit) => cubit.login(loginRequest),
    expect: () => [
      AuthLoading(),
      AuthFailure('An unexpected error occurred: Exception: Login failed')
    ],
  );

  // Test Signup Event
  blocTest<AuthCubit, AuthState>(
    'emits [AuthLoading, AuthSuccess] when signup is successful',
    setUp: () {
      when(mockSignupUseCase.execute(signupRequest)).thenAnswer((_) async => Future.value());
    },
    build: () => authCubit,
    act: (cubit) => cubit.signup(signupRequest),
    expect: () => [AuthLoading(), AuthSuccess()],
  );

  blocTest<AuthCubit, AuthState>(
    'emits [AuthLoading, AuthFailure] when signup fails',
    setUp: () {
      when(mockSignupUseCase.execute(signupRequest)).thenThrow(Exception('Signup failed'));
    },
    build: () => authCubit,
    act: (cubit) => cubit.signup(signupRequest),
    expect: () => [
      AuthLoading(),
      AuthFailure('An unexpected error occurred: Exception: Signup failed')
    ],
  );

  // Test Forget Password Event
  blocTest<AuthCubit, AuthState>(
    'emits [AuthLoading, AuthSuccess] when forget password is successful',
    setUp: () {
      when(mockForgetPasswordUseCase.execute(forgetPasswordRequest)).thenAnswer((_) async => Future.value());
    },
    build: () => authCubit,
    act: (cubit) => cubit.forgetPassword(forgetPasswordRequest),
    expect: () => [AuthLoading(), AuthSuccess()],
  );

  blocTest<AuthCubit, AuthState>(
    'emits [AuthLoading, AuthFailure] when forget password fails',
    setUp: () {
      when(mockForgetPasswordUseCase.execute(forgetPasswordRequest)).thenThrow(Exception('Forget password failed'));
    },
    build: () => authCubit,
    act: (cubit) => cubit.forgetPassword(forgetPasswordRequest),
    expect: () => [
      AuthLoading(),
      AuthFailure('An unexpected error occurred: Exception: Forget password failed')
    ],
  );
}
