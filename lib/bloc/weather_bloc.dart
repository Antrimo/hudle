import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hudle/bloc/weather_event.dart';
import 'package:hudle/bloc/weather_state.dart';
import 'package:hudle/data/repository/weather_repository.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;
  bool isDark = false;

  WeatherBloc(this.weatherRepository) : super(WeatherInitial()) {
    on<WeatherFetched>(_getCurrentWeather);

    on<WeatherThemeChanged>((event, emit) {
      isDark = event.isDarkMode;
      emit(WeatherThemeState(isDark));
    });
  }

  void _getCurrentWeather(
    WeatherFetched event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());
    try {
      final weather = await weatherRepository.getWeatherByCity(event.cityName);
      emit(WeatherSuccess(weather));
    } catch (e) {
      emit(WeatherFailure('Failed to fetch weather'));
    }
  }
}
