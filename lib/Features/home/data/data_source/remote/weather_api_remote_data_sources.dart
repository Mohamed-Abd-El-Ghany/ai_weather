import 'dart:async';
import 'dart:convert';
import 'package:ai_weather/Core/network/remote/api_urls.dart';
import 'package:ai_weather/Features/home/data/data_source/remote/weather_remote_data_sources.dart';
import 'package:ai_weather/Features/home/data/models/weather_response.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@Singleton(as: WeatherApiRemoteDataSources)
class WeatherApiRemoteDataSources implements WeatherRemoteDataSources{
  String baseUrl = ApiUrls.baseUrl;
  String apiKey = ApiUrls.apiKey;

  @override
  Future<WeatherResponse> getWeather(String cityName) async {
    try {
      final url = Uri.parse('$baseUrl/forecast.json?key=$apiKey&q=$cityName&days=3');
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        final errorMessage = getErrorMessage(errorData);
        throw Exception('HTTP ${response.statusCode}: $errorMessage');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return WeatherResponse.fromJson(data);

    } on TimeoutException catch (e) {
      throw Exception('Request timed out: ${e.message}');
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } on FormatException catch (e) {
      throw Exception('Invalid JSON format: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  String getErrorMessage(dynamic errorData) {
    try {
      return errorData['error']['message'] as String;
    } catch (e) {
      return 'Unknown error structure';
    }
  }
}