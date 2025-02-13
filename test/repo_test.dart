import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ai_weather/Features/auth/data/data_source/auth_firebase_service.dart';
import 'package:ai_weather/Features/auth/data/repository/auth_repository_impl.dart';
import 'package:ai_weather/Features/auth/data/models/login_request.dart';
import 'package:ai_weather/Features/auth/data/models/signup_request.dart';
import 'package:ai_weather/Features/auth/data/models/forget_password_request.dart';

// Mock AuthFirebaseService
class MockAuthFirebaseService extends Mock implements AuthFirebaseService {}

void main() {
  late AuthRepositoryImpl authRepository;
  late MockAuthFirebaseService mockAuthFirebaseService;

  setUp(() {
    mockAuthFirebaseService = MockAuthFirebaseService();
    authRepository = AuthRepositoryImpl(mockAuthFirebaseService);
  });

  // Test Login
  test('should call login on AuthFirebaseService', () async {
    // Arrange
    final loginRequest = LoginRequest(email: 'test@example.com', password: 'password');
    when(mockAuthFirebaseService.login(loginRequest)).thenAnswer((_) async {});

    // Act
    await authRepository.login(loginRequest);

    // Assert
    verify(mockAuthFirebaseService.login(loginRequest));
    verifyNoMoreInteractions(mockAuthFirebaseService);
  });

  // Test Signup
  test('should call signup on AuthFirebaseService', () async {
    // Arrange
    final signupRequest = SignupRequest(name: 'Test', phone: '123456789', email: 'test@example.com', password: 'password');
    when(mockAuthFirebaseService.signup(signupRequest)).thenAnswer((_) async {});

    // Act
    await authRepository.signup(signupRequest);

    // Assert
    verify(mockAuthFirebaseService.signup(signupRequest));
    verifyNoMoreInteractions(mockAuthFirebaseService);
  });

  // Test Forget Password
  test('should call forgetPassword on AuthFirebaseService', () async {
    // Arrange
    final forgetPasswordRequest = ForgetPasswordRequest(email: 'test@example.com');
    when(mockAuthFirebaseService.forgetPassword(forgetPasswordRequest)).thenAnswer((_) async {});

    // Act
    await authRepository.forgetPassword(forgetPasswordRequest);

    // Assert
    verify(mockAuthFirebaseService.forgetPassword(forgetPasswordRequest));
    verifyNoMoreInteractions(mockAuthFirebaseService);
  });

  // Test IsLoggedIn
  test('should call isLoggedIn on AuthFirebaseService', () async {
    // Arrange
    when(mockAuthFirebaseService.isLoggedIn()).thenAnswer((_) async => true);

    // Act
    final result = await authRepository.isLoggedIn();

    // Assert
    expect(result, true);
    verify(mockAuthFirebaseService.isLoggedIn());
    verifyNoMoreInteractions(mockAuthFirebaseService);
  });

  // Test Logout
  test('should call isLoggedIn on AuthFirebaseService', () async {
    // Arrange
    when(mockAuthFirebaseService.logout()).thenAnswer((_) async {});

    // Act
    await authRepository.logout();

    // Assert
    verify(mockAuthFirebaseService.logout());
    verifyNoMoreInteractions(mockAuthFirebaseService);
  });
}