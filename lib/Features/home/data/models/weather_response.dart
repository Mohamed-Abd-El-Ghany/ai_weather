class ForecastDay {
  DateTime date;
  double avgTemp;
  double maxTemp;
  double minTemp;
  String conditionText;

  ForecastDay({
    required this.date,
    required this.avgTemp,
    required this.maxTemp,
    required this.minTemp,
    required this.conditionText,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: DateTime.parse(json['date']),
      avgTemp: json['day']['avgtemp_c'],
      maxTemp: json['day']['maxtemp_c'],
      minTemp: json['day']['mintemp_c'],
      conditionText: json['day']['condition']['text'],
    );
  }

  String getImage() {
    String lower = conditionText.toLowerCase();
    if (lower.contains('sunny') ||
        lower.contains('clear') ||
        lower.contains('partly cloudy')) {
      return 'assets/images/clear.png';
    } else if (lower.contains('snow')) {
      return 'assets/images/snow.png';
    } else if (lower.contains('fog') || lower.contains('cloud')) {
      return 'assets/images/cloudy.png';
    } else if (lower.contains('rain')) {
      return 'assets/images/rainy.png';
    } else if (lower.contains('thunder')) {
      return 'assets/images/thunderstorm.png';
    } else {
      return 'assets/images/clear.png';
    }
  }
}

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

  ForecastDay get currentForecast => forecastDays.first;
}
