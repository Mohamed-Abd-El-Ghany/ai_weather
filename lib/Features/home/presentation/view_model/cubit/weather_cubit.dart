import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_weather.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final GetWeatherUseCase getWeatherUseCase;
  String? cityName;

  WeatherCubit({required this.getWeatherUseCase}) : super(WeatherInitial());

  Future<void> getWeather({required String cityName}) async {
    this.cityName = cityName;
    emit(WeatherLoading());
    try {
      final weatherEntity = await getWeatherUseCase.execute(cityName);
      emit(WeatherSuccess(weatherEntity: weatherEntity));
    } on Exception catch (e) {
      emit(WeatherFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}