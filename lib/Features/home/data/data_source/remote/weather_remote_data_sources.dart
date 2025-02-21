import '../../models/weather_response.dart';

abstract class WeatherRemoteDataSources {
  Future<WeatherResponse> getWeather(String cityName);
}