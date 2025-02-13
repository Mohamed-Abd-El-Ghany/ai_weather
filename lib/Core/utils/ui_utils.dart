import 'package:ai_weather/Features/auth/presentation/view/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../resources/app_strings.dart';
import '../resources/app_styles.dart';
import '../resources/color_manager.dart';

class UiUtils {
  static void showLoadingDialog(BuildContext context) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => PopScope(
          canPop: false,
          child: Center(
            child: CircularProgressIndicator(color: Colors.blue),
          ),
        ),
      );

  static void showConnectionDialog(BuildContext context) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => PopScope(
          canPop: false,
          child: AlertDialog(
            backgroundColor: ColorManager.background,
            title: Text(
              AppStrings.connectionProblem,
              textAlign: TextAlign.center,
              style: AppStyles.styleSemiBold24(context),
            ),
            content: Text(
              AppStrings.internetConnection,
              textAlign: TextAlign.center,
              style: AppStyles.styleBold16(context),
            ),
            actions: [
              CustomButton(
                text: AppStrings.ok,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );

  static void showForgetPasswordDialog(BuildContext context) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) => PopScope(
          child: AlertDialog(
            backgroundColor: ColorManager.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
            ),
            content: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                AppStrings.resetPassword,
                textAlign: TextAlign.center,
                style: AppStyles.styleBold16(context),
              ),
            ),
            actions: [
              CustomButton(
                text: AppStrings.ok,
                onPressed: () {
                  Navigator.pop(dialogContext);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );

  static void hideLoadingDialog(BuildContext context) => Navigator.pop(context);

  static void showMessageToast(String message) => Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        webBgColor: "linear-gradient(to right, #F44336FF, #F44336FF)",
        textColor: Colors.white,
        fontSize: 16,
      );
}
