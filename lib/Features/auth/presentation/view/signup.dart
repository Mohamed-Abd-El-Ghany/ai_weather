import 'package:ai_weather/Features/auth/data/models/signup_request.dart';
import 'package:ai_weather/Features/auth/presentation/view/widgets/custom_button.dart';
import 'package:ai_weather/Features/auth/presentation/view/widgets/custom_text_field.dart';
import 'package:ai_weather/Features/auth/presentation/view/widgets/phone_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/resources/app_strings.dart';
import '../../../../Core/resources/app_styles.dart';
import '../../../../Core/resources/color_manager.dart';
import '../../../../Core/routes/routes.dart';
import '../../../../Core/utils/ui_utils.dart';
import '../view_model/cubit/auth_cubit.dart';
import '../view_model/cubit/auth_states.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isObscureText = true;
  String? fullPhoneNumber;

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
                  AppStrings.signup,
                  style: AppStyles.styleSemiBold40(context),
                ),
                SizedBox(height: screenHeight * 0.06),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        AppStrings.fullName,
                        style: AppStyles.styleSemiBold24(context),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.005),
                CustomTextField(
                  controller: nameController,
                  type: TextInputType.name,
                  validator: (value) {
                    if (value == null ||
                        value.trim().length < 4 ||
                        value.length > 20) {
                      return AppStrings.enterName;
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
                        AppStrings.phone,
                        style: AppStyles.styleSemiBold24(context),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.005),
                PhoneField(
                  phoneController: phoneController,
                  onChanged: (phoneNumber) {
                    setState(
                      () {
                        fullPhoneNumber = phoneNumber;
                      },
                    );
                  },
                ),
                SizedBox(height: screenHeight * 0.01),
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
                        if (formKey.currentState!.validate() &&
                            phoneController.text.isNotEmpty) {
                          cubit.signup(
                            SignupRequest(
                              name: nameController.text,
                              phone: phoneController.text,
                              email: emailController.text,
                              password: passwordController.text,
                            ),
                          );
                        } else {
                          UiUtils.showMessageToast(
                            AppStrings.enterAllData,
                          );
                        }
                      },
                      text: AppStrings.signup,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.1),
                TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, Routes.login),
                  child: Text(
                    AppStrings.haveAccount,
                    style: AppStyles.styleRegular18(context),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    formKey.currentState?.dispose();
    super.dispose();
  }
}
