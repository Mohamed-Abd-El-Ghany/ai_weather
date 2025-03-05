import 'package:flutter/material.dart';
import '../../../../../Core/resources/app_styles.dart';

class WeatherForecastDetails extends StatelessWidget {
  final String cityName;
  final String imagePath;
  final int avgTemp;
  final int maxTemp;
  final int minTemp;
  final int avgHumidity;
  final String conditionText;

  const WeatherForecastDetails({
    super.key,
    required this.cityName,
    required this.imagePath,
    required this.avgTemp,
    required this.maxTemp,
    required this.minTemp,
    required this.avgHumidity,
    required this.conditionText,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            cityName,
            style: AppStyles.styleSemiBold40(context),
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              imagePath,
              width: screenWidth * 0.13,
              height: screenWidth * 0.13,
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'avgTemp: $avgTemp',
                style: AppStyles.styleSemiBold24(context),
              ),
            ),
            Column(
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'maxTemp: $maxTemp',
                    style: AppStyles.styleBold16(context),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'minTemp: $minTemp',
                    style: AppStyles.styleBold16(context),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.02),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'avgHumidity: $avgHumidity',
            style: AppStyles.styleSemiBold24(context),
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            conditionText,
            style: AppStyles.styleSemiBold40(context).copyWith(fontSize: 30),
          ),
        ),
      ],
    );
  }
}