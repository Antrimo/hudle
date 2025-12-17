import 'package:hudle/data/models/weather_model.dart';

sealed class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherSuccess extends WeatherState {
  final WeatherModel weather;

  WeatherSuccess(this.weather);
}

class WeatherFailure extends WeatherState {
  final String message;

  WeatherFailure(this.message);
}
