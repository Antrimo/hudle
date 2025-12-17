import 'package:hudle/data/models/weather_model.dart';

sealed class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherSuccess extends WeatherState {
  final WeatherModel weather;
  final bool isDarkMode;
  final bool isCelsius;

  WeatherSuccess(this.weather, this.isDarkMode, this.isCelsius);
}

class WeatherFailure extends WeatherState {
  final String message;

  WeatherFailure(this.message);
}

class WeatherThemeState extends WeatherState {
  final bool isDark;

  WeatherThemeState(this.isDark);
}
