import 'package:hudle/data/local/weather_cache_local.dart';
import 'package:hudle/data/local/weather_history_local.dart';
import 'package:hudle/data/models/weather_model.dart';
import 'package:hudle/data/services/weather_api_service.dart';

// Repository managing weather data fetching and caching instead of bloc

class WeatherRepository {
  final WeatherApiService weatherData;
  final WeatherCacheLocal cache;
  final WeatherHistoryLocal storeHistory;

  WeatherRepository(this.weatherData, this.cache, this.storeHistory);

  Future<WeatherModel> getWeatherByCity(String cityName) async {
    try {
      final weather = await weatherData.fetchWeather(cityName);
      await cache.save(weather);
      await storeHistory.saveCity(cityName);

      return weather;
    } catch (e) {
      final cachedWeather = await cache.load();
      if (cachedWeather != null) {
        return cachedWeather;
      }
      rethrow;
    }
  }
}
