import 'package:ai_weather/Features/home/presentation/view/widgets/hello_user.dart';
import 'package:ai_weather/Features/home/presentation/view/widgets/forecast_date_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../Core/di/service_locator.dart';
import '../../../../Core/network/location helper/location_service.dart';
import '../../../../Core/resources/app_strings.dart';
import '../../../../Core/resources/app_styles.dart';
import '../../../../Core/resources/color_manager.dart';
import '../view_model/cubit/weather_cubit.dart';
import '../view_model/cubit/weather_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userName = "";
  String city = '';
  bool _isLoading = true;
  int selectedForecastIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  Future<void> _fetchAllData() async {
    try {
      await Future.wait([
        _fetchCity(),
        _fetchUserName(),
      ]);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchUserName() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('Users').doc(user.uid).get();
        if (mounted && doc.exists) {
          setState(() {
            userName = doc['name'];
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user data: $e");
      }
    }
  }

  Future<void> _fetchCity() async {
    try {
      final result = await LocationService.getCityName();
      setState(() {
        city = result;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching city: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: ColorManager.background,
        body: Center(
          child: CircularProgressIndicator(
            color: ColorManager.blue,
          ),
        ),
      );
    }

    return BlocProvider(
      create: (context) => sl.get<WeatherCubit>()..getWeather(cityName: city),
      child: Scaffold(
        backgroundColor: ColorManager.background,
        body: BlocBuilder<WeatherCubit, WeatherState>(
          builder: (context, state) {
            if (state is WeatherLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: ColorManager.blue,
                ),
              );
            } else if (state is WeatherSuccess) {
              final forecastDays = state.weatherResponse.forecastDays;
              final firstForecastDate = forecastDays[0].date;
              final forecast = forecastDays[selectedForecastIndex];
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight * 0.07),
                      HelloUser(userName: userName),
                      SizedBox(height: screenHeight * 0.09),
                      ForecastDatePicker(
                        leftPadding: screenWidth * 0.1518,
                        width: screenWidth * 0.2,
                        height: screenHeight * 0.18,
                        firstForecastDate: firstForecastDate,
                        forecastDays: forecastDays,
                        onDateChanged: (index) {
                          setState(() {
                            selectedForecastIndex = index;
                          });
                        },
                      ),
                      SizedBox(height: screenHeight * 0.07),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          BlocProvider.of<WeatherCubit>(context).cityName ?? 'City',
                          style: AppStyles.styleSemiBold40(context),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            forecast.getImage(),
                            width: screenWidth * 0.12,
                            height: screenWidth * 0.12,
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              forecast.avgTemp.toInt().toString(),
                              style: AppStyles.styleSemiBold40(context).copyWith(fontSize: 30),
                            ),
                          ),
                          Column(
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'maxTemp: ${forecast.maxTemp.toInt()}',
                                  style: AppStyles.styleBold16(context).copyWith(fontSize: 18),
                                ),
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'minTemp: ${forecast.minTemp.toInt()}',
                                  style: AppStyles.styleBold16(context).copyWith(fontSize: 18),
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
                          forecast.conditionText,
                          style: AppStyles.styleSemiBold40(context).copyWith(fontSize: 30),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                    ],
                  ),
                ),
              );
            } else if (state is WeatherFailure) {
              return Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    state.error,
                    style: AppStyles.styleRegular18(context),
                  ),
                ),
              );
            } else {
              return Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    AppStrings.failedData,
                    style: AppStyles.styleRegular18(context),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
