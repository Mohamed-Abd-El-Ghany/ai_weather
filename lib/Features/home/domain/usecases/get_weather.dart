import '../entities/weather_entity.dart';
import '../repository/weather_repository.dart';

class GetWeatherUseCase {
  final WeatherRepository _repository;

  GetWeatherUseCase(this._repository);

  Future<WeatherEntity> execute(String cityName) async {
    return await _repository.getWeather(cityName);
  }
}
