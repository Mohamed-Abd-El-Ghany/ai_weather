import 'package:ai_weather/Features/auth/data/models/login_request.dart';
import 'package:ai_weather/Features/auth/presentation/view/widgets/custom_button.dart';
import 'package:ai_weather/Features/auth/presentation/view/widgets/custom_text_field.dart';
import 'package:ai_weather/Features/auth/presentation/view/widgets/forget_password_button.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/resources/app_strings.dart';
import '../../../../Core/resources/app_styles.dart';
import '../../../../Core/resources/color_manager.dart';
import '../../../../Core/routes/routes.dart';
import '../../../../Core/utils/ui_utils.dart';
import '../view_model/cubit/auth_cubit.dart';
import '../view_model/cubit/auth_states.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController emailController2 = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isObscureText = true;

  @override
  void initState() {
    Future.delayed(
      const Duration(microseconds: 0),
      () async {
        if (await _checkConnection() == false) {
          if (!mounted) return;
          UiUtils.showConnectionDialog(context);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    AuthCubit cubit = AuthCubit.get(context);
    return Scaffold(
      backgroundColor: ColorManager.background,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.09),
                Text(
                  AppStrings.login,
                  style: AppStyles.styleSemiBold40(context),
                ),
                SizedBox(height: screenHeight * 0.04),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        AppStrings.email,
                        style: AppStyles.styleSemiBold24(context),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.005),
                CustomTextField(
                  controller: emailController,
                  type: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.emailRequired;
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return AppStrings.enterEmail;
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.01),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        AppStrings.password,
                        style: AppStyles.styleSemiBold24(context),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.005),
                CustomTextField(
                  isVisible: isObscureText,
                  controller: passwordController,
                  type: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.passwordRequired;
                    }
                    if (value.length < 6) {
                      return AppStrings.passwordLong;
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(
                        () {
                          isObscureText = !isObscureText;
                        },
                      );
                    },
                    icon: Icon(
                      Icons.visibility_outlined,
                      color: ColorManager.white,
                      size: 27,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: ForgetPasswordButton(
                        emailController2: emailController2,
                        cubit: cubit,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.05),
                BlocListener<AuthCubit, AuthState>(
                  listener: (_, state) {
                    if (state is AuthLoading) {
                      UiUtils.showLoadingDialog(context);
                    } else if (state is AuthFailure) {
                      UiUtils.hideLoadingDialog(context);
                      UiUtils.showMessageToast(state.error);
                    } else if (state is AuthSuccess) {
                      UiUtils.hideLoadingDialog(context);
                      Navigator.pushReplacementNamed(context, Routes.home);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: CustomButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          cubit.login(
                            LoginRequest(
                              email: emailController.text,
                              password: passwordController.text,
                            ),
                          );
                        }
                      },
                      text: AppStrings.login,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.15),
                TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, Routes.signup),
                  child: Text(
                    AppStrings.dontHaveAccount,
                    style: AppStyles.styleRegular18(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _checkConnection() async {
    bool result = await InternetConnection().hasInternetAccess;
    return result;
  }

  @override
  void dispose() {
    emailController.dispose();
    emailController2.dispose();
    passwordController.dispose();
    formKey.currentState?.dispose();
    super.dispose();
  }
}
