import 'package:get_it/get_it.dart';
import '../../Features/auth/data/data_source/auth_firebase_service.dart';
import '../../Features/auth/data/repository/auth_repository_impl.dart';
import '../../Features/auth/domain/repository/auth_repository.dart';
import '../../Features/auth/domain/usecases/forget_password.dart';
import '../../Features/auth/domain/usecases/is_logged_in.dart';
import '../../Features/auth/domain/usecases/login.dart';
import '../../Features/auth/domain/usecases/logout.dart';
import '../../Features/auth/domain/usecases/signup.dart';
import '../../Features/auth/presentation/view_model/cubit/auth_cubit.dart';
import '../../Features/home/data/data_source/remote/weather_api_remote_data_sources.dart';
import '../../Features/home/data/data_source/remote/weather_remote_data_sources.dart';
import '../../Features/home/data/repository/weather_repository_impl.dart';
import '../../Features/home/domain/repository/weather_repository.dart';
import '../../Features/home/domain/usecases/get_weather.dart';
import '../../Features/home/presentation/view_model/cubit/weather_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Register Services
  sl.registerLazySingleton<AuthFirebaseService>(() => AuthFirebaseService());

  // Register Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthFirebaseService>()),
  );

  sl.registerLazySingleton<WeatherRemoteDataSources>(
      () => WeatherApiRemoteDataSources());

  sl.registerLazySingleton<WeatherRepository>(
      () => WeatherRepositoryImpl(sl<WeatherRemoteDataSources>()));

  // Register Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignupUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => ForgetPasswordUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => IsLoggedInUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetWeatherUseCase(sl<WeatherRepository>()));

  // Register Blocs/Cubits
  sl.registerFactory(
    () => AuthCubit(
      loginUseCase: sl<LoginUseCase>(),
      signupUseCase: sl<SignupUseCase>(),
      forgetPasswordUseCase: sl<ForgetPasswordUseCase>(),
    ),
  );

  sl.registerFactory(
    () => WeatherCubit(
      getWeatherUseCase: sl<GetWeatherUseCase>(),
    ),
  );
}
