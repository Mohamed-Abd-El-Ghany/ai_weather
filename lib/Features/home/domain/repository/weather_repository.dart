import '../../data/models/weather_response.dart';

abstract class WeatherRepository {
  Future<WeatherResponse> getWeather(String cityName);
}
