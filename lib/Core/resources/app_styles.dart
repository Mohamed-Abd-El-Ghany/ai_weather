import 'package:ai_weather/Core/resources/size_config.dart';
import 'package:flutter/material.dart';
import 'color_manager.dart';

abstract class AppStyles {
  static TextStyle styleBold16(BuildContext context) {
    return TextStyle(
      color: ColorManager.white,
      fontSize: getResponsiveFontSize(
        context,
        fontSize: 16,
      ),
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle styleSemiBold40(BuildContext context) {
    return TextStyle(
      color: ColorManager.white,
      fontSize: getResponsiveFontSize(
        context,
        fontSize: 40,
      ),
      fontWeight: FontWeight.w900,
    );
  }

  static TextStyle styleRegular18(BuildContext context) {
    return TextStyle(
      color: ColorManager.blue,
      fontSize: getResponsiveFontSize(
        context,
        fontSize: 18,
      ),
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle styleSemiBold24(BuildContext context) {
    return TextStyle(
      color: ColorManager.white,
      fontSize: getResponsiveFontSize(
        context,
        fontSize: 24,
      ),
      fontWeight: FontWeight.w700,
    );
  }
}

double getResponsiveFontSize(context, {required double fontSize}) {
  double scaleFactor = getScaleFactor(context);
  double responsiveFontSize = fontSize * scaleFactor;

  double lowerLimit = fontSize * 0.9;
  double upperLimit = fontSize * 1.6;

  return responsiveFontSize.clamp(
    lowerLimit,
    upperLimit,
  );
}

double getScaleFactor(context) {

  double width = MediaQuery.sizeOf(context).width;
  if (width < SizeConfig.tablet) {
    return width / 550;
  } else if (width < SizeConfig.desktop) {
    return width / 1000;
  } else {
    return width / 1920;
  }
}
