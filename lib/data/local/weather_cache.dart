import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hudle/data/models/weather_model.dart';

class WeatherCache {
  static const _cacheKey = 'cached_weather';

  // Saves the weather data to local storage
  Future<void> save(WeatherModel weather) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_cacheKey, jsonEncode(weather.toJson()));
  }

  // Loads the weather data from local storage
  Future<WeatherModel?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_cacheKey);

    if (data == null) return null;

    return WeatherModel.fromCache(jsonDecode(data));
  }
}
