import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../Core/resources/app_strings.dart';
import '../../../../../Core/resources/app_styles.dart';
import '../../../../../Core/resources/color_manager.dart';
import '../../../../../Core/utils/ui_utils.dart';
import '../../../data/models/forget_password_request.dart';
import '../../view_model/cubit/auth_cubit.dart';
import '../../view_model/cubit/auth_states.dart';
import 'custom_button.dart';
import 'custom_text_field.dart';

class ForgetPasswordButton extends StatefulWidget {
  const ForgetPasswordButton({
    super.key,
    required this.emailController2,
    required this.cubit,
  });

  final TextEditingController emailController2;
  final AuthCubit cubit;

  @override
  State<ForgetPasswordButton> createState() => _ForgetPasswordButtonState();
}

class _ForgetPasswordButtonState extends State<ForgetPasswordButton> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: ColorManager.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
          ),
          context: context,
          builder: (context) {
            return SizedBox(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 40,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: screenHeight * 0.04),
                              Text(
                                textAlign: TextAlign.center,
                                AppStrings.enterYourEmail,
                                style: AppStyles.styleSemiBold24(context),
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
                                controller: widget.emailController2,
                                type: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.emailRequired;
                                  }
                                  if (!RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                      .hasMatch(value)) {
                                    return AppStrings.enterEmail;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.03),
                                child: BlocListener<AuthCubit, AuthState>(
                                  listener: (_, state) {
                                    if (state is AuthLoading) {
                                      UiUtils.showLoadingDialog(context);
                                    } else if (state is AuthFailure) {
                                      UiUtils.hideLoadingDialog(context);
                                      UiUtils.showMessageToast(state.error);
                                    } else if (state is AuthSuccess) {
                                      UiUtils.hideLoadingDialog(context);
                                      Navigator.pop(context);
                                      UiUtils.showForgetPasswordDialog(context);
                                    }
                                  },
                                  child: CustomButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        widget.cubit.forgetPassword(
                                          ForgetPasswordRequest(
                                            email: widget.emailController2.text,
                                          ),
                                        );
                                      }
                                    },
                                    text: AppStrings.submit,
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Text(
        AppStrings.forgetPassword,
        style: AppStyles.styleBold16(context),
      ),
    );
  }
}
