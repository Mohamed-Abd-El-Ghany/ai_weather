import '../../domain/entities/weather_entity.dart';
import '../models/weather_response.dart';

class WeatherMapper {
  static WeatherEntity mapResponseToEntity(
    WeatherResponse response,
    String cityName,
  ) {
    return WeatherEntity(
      forecastDays: response.forecastDays
          .map(
            (e) => ForecastDayEntity(
              date: e.date,
              avgTemp: e.avgTemp,
              maxTemp: e.maxTemp,
              minTemp: e.minTemp,
              avgHumidity: e.avgHumidity,
              conditionText: e.conditionText,
            ),
          )
          .toList(),
      cityName: cityName,
    );
  }
}
