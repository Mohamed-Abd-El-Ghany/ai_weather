import '../../../data/models/weather_response.dart';

abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherSuccess extends WeatherState {
  WeatherResponse weatherResponse;

  WeatherSuccess({required this.weatherResponse});
}

class WeatherFailure extends WeatherState {
  final String error;

  WeatherFailure(this.error);
}
