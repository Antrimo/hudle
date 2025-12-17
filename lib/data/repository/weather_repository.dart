import 'package:hudle/data/services/api_service.dart';

class WeatherRepository {
  final ApiService weatherData;

  WeatherRepository({required this.weatherData});

  Future getWeather(String cityName) async {
    return await weatherData.fetchWeather(cityName);
  }
}
