import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hudle/bloc/weather_event.dart';
import 'package:hudle/bloc/weather_state.dart';
import 'package:hudle/data/repository/weather_repository.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;
  bool isDarkMode = false;
  bool isCelsius = true;
  String? _lastCity;

  WeatherBloc(this.weatherRepository) : super(WeatherInitial()) {
    on<WeatherFetched>(_getCurrentWeather);
    on<WeatherThemeToggled>(_toggleTheme);
    on<WeatherUnitToggled>(_toggleUnit);
    on<WeatherRefreshRequested>(_onRefreshWeather);
  }

  void _getCurrentWeather(
    WeatherFetched event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());
    try {
      final weather = await weatherRepository.getWeatherByCity(event.cityName);
      emit(WeatherSuccess(weather, isDarkMode, isCelsius));
    } catch (e) {
      emit(WeatherFailure('failed to find city and fetch weather'));
    }
  }

  void _toggleTheme(WeatherThemeToggled event, Emitter<WeatherState> emit) {
    isDarkMode = !isDarkMode;

    if (state is WeatherSuccess) {
      final current = state as WeatherSuccess;
      emit(WeatherSuccess(current.weather, isDarkMode, isCelsius));
    }
  }

  void _toggleUnit(WeatherUnitToggled event, Emitter<WeatherState> emit) {
    isCelsius = !isCelsius;

    if (state is WeatherSuccess) {
      final current = state as WeatherSuccess;
      emit(WeatherSuccess(current.weather, isDarkMode, isCelsius));
    }
  }

  Future<void> _onRefreshWeather(
    WeatherRefreshRequested event,
    Emitter<WeatherState> emit,
  ) async {
    if (_lastCity == null) return;

    emit(WeatherLoading());
    try {
      final weather = await weatherRepository.getWeatherByCity(_lastCity!);
      emit(WeatherSuccess(weather, isDarkMode, isCelsius));
    } catch (e) {
      emit(WeatherFailure(e.toString()));
    }
  }
}
