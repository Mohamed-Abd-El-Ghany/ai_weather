import '../../data/models/weather_response.dart';
import '../repository/weather_repository.dart';

class GetWeatherUseCase {
  final WeatherRepository _repository;

  GetWeatherUseCase(this._repository);

  Future<WeatherResponse> execute(String cityName) async {
    return await _repository.getWeather(cityName);
  }
}