import 'package:ai_weather/Features/splash/view_model/splash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/di/service_locator.dart';
import '../../auth/domain/usecases/is_logged_in.dart';
import '../../auth/presentation/view_model/cubit/auth_cubit.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(DisplaySplash());

  void appStarted(AuthCubit authCubit) async {
    await Future.delayed(const Duration(seconds: 2));
    var isLoggedIn = await sl<IsLoggedInUseCase>().execute();
    if (isLoggedIn) {
      emit(Authenticated());
    } else {
      emit(UnAuthenticated());
    }
  }
}
