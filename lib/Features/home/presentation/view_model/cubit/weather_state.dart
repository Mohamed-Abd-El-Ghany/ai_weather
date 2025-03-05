import '../../../domain/entities/weather_entity.dart';

abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherSuccess extends WeatherState {
  WeatherEntity weatherEntity;

  WeatherSuccess({required this.weatherEntity});
}

class WeatherFailure extends WeatherState {
  final String error;

  WeatherFailure(this.error);
}
