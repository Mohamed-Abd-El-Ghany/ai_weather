class WeatherResponse {
  List<ForecastDay> forecastDays;

  WeatherResponse({
    required this.forecastDays,
  });

  factory WeatherResponse.fromJson(dynamic data) {
    var forecastList = data['forecast']['forecastday'] as List;
    List<ForecastDay> forecastDays =
        forecastList.map((e) => ForecastDay.fromJson(e)).toList();
    return WeatherResponse(forecastDays: forecastDays);
  }
}

class ForecastDay {
  DateTime date;
  double avgTemp;
  double maxTemp;
  double minTemp;
  double avgHumidity;
  String conditionText;

  ForecastDay({
    required this.date,
    required this.avgTemp,
    required this.maxTemp,
    required this.minTemp,
    required this.avgHumidity,
    required this.conditionText,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: DateTime.parse(json['date']),
      avgTemp: (json['day']['avgtemp_c'] as num).toDouble(),
      maxTemp: (json['day']['maxtemp_c'] as num).toDouble(),
      minTemp: (json['day']['mintemp_c'] as num).toDouble(),
      avgHumidity: (json['day']['avghumidity'] as num).toDouble(),
      conditionText: json['day']['condition']['text'],
    );
  }
}