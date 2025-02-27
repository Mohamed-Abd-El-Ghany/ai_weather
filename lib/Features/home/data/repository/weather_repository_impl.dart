import 'package:injectable/injectable.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/repository/weather_repository.dart';
import '../data_source/remote/weather_remote_data_sources.dart';
import '../mappers/weather_mapper.dart';

@Singleton(as: WeatherRepository)
class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSources _weatherRemoteDataSources;

  const WeatherRepositoryImpl(this._weatherRemoteDataSources);

  @override
  Future<WeatherEntity> getWeather(String cityName) async {
    final response = await _weatherRemoteDataSources.getWeather(cityName);
    return WeatherMapper.mapResponseToEntity(response, cityName);
  }
}
