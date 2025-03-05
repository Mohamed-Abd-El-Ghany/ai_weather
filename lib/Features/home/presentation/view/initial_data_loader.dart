import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../Core/di/service_locator.dart';
import '../../../../Core/network/ai prediction/ai_prediction.dart';
import '../../../../Core/network/location helper/location_service.dart';
import '../../../../Core/resources/color_manager.dart';
import '../view_model/cubit/weather_cubit.dart';
import '../view_model/cubit/weather_state.dart';
import 'home_content.dart';

class InitialDataLoader extends StatefulWidget {
  const InitialDataLoader({super.key});

  @override
  State<InitialDataLoader> createState() => _InitialDataLoaderState();
}

class _InitialDataLoaderState extends State<InitialDataLoader> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userName = '';
  String city = '';
  bool _isLoading = true;
  String aiPrediction = '';

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    await _fetchUserName();
    await _fetchCity();
    await _fetchAiPrediction();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchUserName() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('Users').doc(user.uid).get();
      if (mounted && doc.exists) {
        userName = doc['name'];
      }
    }
  }

  Future<void> _fetchCity() async {
    final result = await LocationService.getCityName();
    setState(() {
      city = result;
    });
  }

  Future<void> _fetchAiPrediction() async {
    final weatherCubit = sl.get<WeatherCubit>();
    await weatherCubit.getWeather(cityName: city);
    if (weatherCubit.state is WeatherSuccess) {
      final weatherEntity = (weatherCubit.state as WeatherSuccess).weatherEntity;
      final binaryFeatures = weatherEntity.getBinaryFeatures();
      final result = await AiPrediction.getPrediction(binaryFeatures);
      setState(() {
        aiPrediction = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: ColorManager.background,
        body: Center(
          child: CircularProgressIndicator(color: ColorManager.blue),
        ),
      );
    }
    return HomeContent(
      userName: userName,
      city: city,
      aiPrediction: aiPrediction,
    );
  }
}
