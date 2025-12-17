import 'package:hudle/data/models/weather_model.dart';
import 'package:hudle/data/services/weather_api_service.dart';

class WeatherRepository {
  final WeatherApiService weatherData;

  WeatherRepository(this.weatherData);

  Future<WeatherModel> getWeatherByCity(String cityName) {
    return weatherData.fetchWeather(cityName);
  }
}
