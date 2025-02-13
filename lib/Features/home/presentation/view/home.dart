import 'package:flutter/material.dart';
import '../../../../Core/di/service_locator.dart';
import '../../../../Core/resources/app_strings.dart';
import '../../../../Core/resources/app_styles.dart';
import '../../../../Core/resources/color_manager.dart';
import '../../../../Core/routes/routes.dart';
import '../../../auth/domain/usecases/logout.dart';
import '../../../auth/presentation/view/widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppStrings.hi,
                style: AppStyles.styleSemiBold40(context),
              ),
              SizedBox(height: 20),
              CustomButton(
                onPressed: () async{
                  await sl<LogoutUseCase>().execute();
                  Navigator.pushReplacementNamed(context, Routes.login);
                },
                text: AppStrings.logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}