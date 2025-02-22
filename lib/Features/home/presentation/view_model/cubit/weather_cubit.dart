import 'package:ai_weather/Features/home/presentation/view_model/cubit/weather_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_weather.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final GetWeatherUseCase getWeatherUseCase;
  String? cityName;

  WeatherCubit({required this.getWeatherUseCase}) : super(WeatherInitial());

  Future<void> getWeather({required String cityName}) async {
    this.cityName = cityName;
    emit(WeatherLoading());
    try {
      final weatherResponse = await getWeatherUseCase.execute(cityName);
      emit(WeatherSuccess(weatherResponse: weatherResponse));
    } on Exception catch (e) {
      emit(WeatherFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}