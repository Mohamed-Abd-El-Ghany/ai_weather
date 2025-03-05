import 'package:ai_weather/Features/home/presentation/view/widgets/forecast_date_picker.dart';
import 'package:ai_weather/Features/home/presentation/view/widgets/hello_user.dart';
import 'package:ai_weather/Features/home/presentation/view/widgets/loading_widget.dart';
import 'package:ai_weather/Features/home/presentation/view/widgets/weather_forecast_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/resources/app_styles.dart';
import '../../../../Core/resources/color_manager.dart';
import '../../../../Core/di/service_locator.dart';
import '../view_model/cubit/weather_cubit.dart';
import '../view_model/cubit/weather_state.dart';

class HomeContent extends StatefulWidget {
  final String userName;
  final String city;
  final String aiPrediction;

  const HomeContent({
    super.key,
    required this.userName,
    required this.city,
    required this.aiPrediction,
  });

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  int selectedForecastIndex = 0;

  void _onDateChanged(int index) {
    setState(() {
      selectedForecastIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) =>
          sl.get<WeatherCubit>()..getWeather(cityName: widget.city),
      child: Scaffold(
        backgroundColor: ColorManager.background,
        body: BlocBuilder<WeatherCubit, WeatherState>(
          builder: (context, state) {
            if (state is WeatherLoading) {
              return const LoadingWidget();
            } else if (state is WeatherSuccess) {
              final forecastDays = state.weatherEntity.forecastDays;
              final firstForecastDate = forecastDays[0].date;
              final forecast = forecastDays[selectedForecastIndex];
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight * 0.06),
                      HelloUser(userName: widget.userName),
                      SizedBox(height: screenHeight * 0.08),
                      ForecastDatePicker(
                        leftPadding: screenWidth * 0.1518,
                        width: screenWidth * 0.2,
                        height: screenHeight * 0.18,
                        firstForecastDate: firstForecastDate,
                        forecastDays: forecastDays,
                        onDateChanged: _onDateChanged,
                      ),
                      SizedBox(height: screenHeight * 0.06),
                      WeatherForecastDetails(
                        cityName: state.weatherEntity.cityName,
                        imagePath: forecast.getImage(),
                        avgTemp: forecast.avgTemp.toInt(),
                        maxTemp: forecast.maxTemp.toInt(),
                        minTemp: forecast.minTemp.toInt(),
                        avgHumidity: forecast.avgHumidity.toInt(),
                        conditionText: forecast.conditionText,
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.aiPrediction,
                          style: AppStyles.styleBold16(context),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is WeatherFailure) {
              return Center(
                child: Text(
                  state.error,
                  style: AppStyles.styleBold16(context),
                ),
              );
            } else {
              return Center(
                child: Text(
                  "Failed to load data",
                  style: AppStyles.styleBold16(context),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}