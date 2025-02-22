import 'package:injectable/injectable.dart';
import '../../domain/repository/weather_repository.dart';
import '../data_source/remote/weather_remote_data_sources.dart';
import '../models/weather_response.dart';

@Singleton(as: WeatherRepository)
class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSources _weatherRemoteDataSources;
  const WeatherRepositoryImpl(this._weatherRemoteDataSources);

  @override
  Future<WeatherResponse> getWeather(String cityName) async {
      return await _weatherRemoteDataSources.getWeather(cityName);
  }
}
