import 'package:ai_weather/Features/home/presentation/view/widgets/hello_user.dart';
import 'package:ai_weather/Features/home/presentation/view/widgets/forecast_date_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../Core/di/service_locator.dart';
import '../../../../Core/network/ai prediction/ai_prediction.dart';
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
  String userName = '';
  String city = '';
  String aiPrediction = '';
  bool _isLoading = true;
  int selectedForecastIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    try {
      await Future.wait([
        _fetchUserName(),
        _fetchCity(),
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

  Future<void> _fetchAiPrediction(BuildContext blocContext) async {
    try {
      final weatherCubit = BlocProvider.of<WeatherCubit>(blocContext);
      if (weatherCubit.state is WeatherSuccess) {
        final weatherEntity = (weatherCubit.state as WeatherSuccess).weatherEntity;
        final binaryFeatures = weatherEntity.getBinaryFeatures();
        final result = await AiPrediction.getPrediction(binaryFeatures);
        setState(() {
          aiPrediction = result;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching AI prediction: $e");
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
        body: BlocListener<WeatherCubit, WeatherState>(
          listener: (context, state) {
            if (state is WeatherSuccess) {
              _fetchAiPrediction(context);
            }
          },
          child: BlocBuilder<WeatherCubit, WeatherState>(
            builder: (context, state) {
              if (state is WeatherLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: ColorManager.blue,
                  ),
                );
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
                        HelloUser(userName: userName),
                        SizedBox(height: screenHeight * 0.08),
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
                        SizedBox(height: screenHeight * 0.06),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            state.weatherEntity.cityName,
                            style: AppStyles.styleSemiBold40(context),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              forecast.getImage(),
                              width: screenWidth * 0.13,
                              height: screenWidth * 0.13,
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'avgTemp: ${forecast.avgTemp.toInt()}',
                                style: AppStyles.styleSemiBold24(context),
                              ),
                            ),
                            Column(
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'maxTemp: ${forecast.maxTemp.toInt()}',
                                    style: AppStyles.styleBold16(context),
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'minTemp: ${forecast.minTemp.toInt()}',
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
                            'avgHumidity: ${forecast.avgHumidity.toInt()}',
                            style: AppStyles.styleSemiBold24(context),
                          ),
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
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            aiPrediction,
                            style: AppStyles.styleBold16(context),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is WeatherFailure) {
                if (kDebugMode) {
                  print(state.error);
                }
                return Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      state.error,
                      style: AppStyles.styleBold16(context),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      AppStrings.failedData,
                      style: AppStyles.styleBold16(context),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

