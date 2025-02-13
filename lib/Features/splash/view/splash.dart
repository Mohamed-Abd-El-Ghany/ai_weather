import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/resources/app_strings.dart';
import '../../../Core/resources/app_styles.dart';
import '../../../Core/resources/color_manager.dart';
import '../../../Core/routes/routes.dart';
import '../../auth/presentation/view_model/cubit/auth_cubit.dart';
import '../view_model/splash_cubit.dart';
import '../view_model/splash_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthCubit authCubit;
  @override
  Widget build(BuildContext context) {
    authCubit = AuthCubit.get(context);
    return BlocProvider(
      create: (BuildContext context) {
        return SplashCubit()..appStarted(authCubit);
      },
      child: BlocListener<SplashCubit,SplashState>(
        listener: (context, state) {
          if(state is UnAuthenticated){
            Navigator.pushReplacementNamed(context, Routes.login);
          }
          if(state is Authenticated) {
            Navigator.pushReplacementNamed(context, Routes.home);
          }
        },
        child: Scaffold(
          backgroundColor: ColorManager.background,
          body: Center(
            child: Text(
              AppStrings.aiWeather,
              style: AppStyles.styleSemiBold40(context),
            ),
          ),
        ),
      ),
    );
  }
}