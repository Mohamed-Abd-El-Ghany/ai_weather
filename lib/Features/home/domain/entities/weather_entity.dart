class WeatherEntity {
  final List<ForecastDayEntity> forecastDays;
  final String cityName;

  WeatherEntity({
    required this.forecastDays,
    required this.cityName,
  });

  ForecastDayEntity get currentForecast => forecastDays.first;

  List<int> _convertToBinaryFeatures(ForecastDayEntity forecast) {
    final lowerCondition = forecast.conditionText.toLowerCase();

    final isRainy = lowerCondition.contains('rain') ||
            lowerCondition.contains('snow') ||
            lowerCondition.contains('fog') ||
            lowerCondition.contains('thunder')
        ? 1 : 0;

    final isSunny = lowerCondition.contains('sunny') ||
            lowerCondition.contains('clear') ||
            lowerCondition.contains('partly cloudy')
        ? 1 : 0;

    final isHot = forecast.avgTemp > 25 ? 1 : 0;

    final isMild = forecast.avgTemp <= 25 ? 1 : 0;

    final isNormalHumidity =
        (forecast.avgHumidity >= 30 && forecast.avgHumidity <= 60) ? 1 : 0;

    return [isRainy, isSunny, isHot, isMild, isNormalHumidity];
  }

  List<int> getBinaryFeatures() {
    return _convertToBinaryFeatures(currentForecast);
  }
}

class ForecastDayEntity {
  final DateTime date;
  final double avgTemp;
  final double maxTemp;
  final double minTemp;
  final double avgHumidity;
  final String conditionText;

  ForecastDayEntity({
    required this.date,
    required this.avgTemp,
    required this.maxTemp,
    required this.minTemp,
    required this.avgHumidity,
    required this.conditionText,
  });

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
