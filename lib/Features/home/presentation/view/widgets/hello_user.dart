import 'package:flutter/material.dart';
import '../../../../../Core/di/service_locator.dart';
import '../../../../../Core/resources/app_strings.dart';
import '../../../../../Core/resources/app_styles.dart';
import '../../../../../Core/resources/color_manager.dart';
import '../../../../../Core/routes/routes.dart';
import '../../../../auth/domain/usecases/logout.dart';

class HelloUser extends StatelessWidget {
  const HelloUser({
    super.key,
    required this.userName,
  });

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  AppStrings.hello,
                  style: AppStyles.styleRegular18(context).copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  userName,
                  style: AppStyles.styleSemiBold24(context),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: IconButton(
              onPressed: () async {
                await sl<LogoutUseCase>().execute();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(
                    context,
                    Routes.login,
                  );
                }
              },
              icon: Icon(
                Icons.logout,
                color: ColorManager.white,
                size: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
