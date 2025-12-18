import 'package:shared_preferences/shared_preferences.dart';

class WeatherHistoryLocal {
  static const _key = 'search_history';
  static const _maxItems = 5;

  Future<void> saveCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_key) ?? [];

    history.remove(city);
    history.insert(0, city);

    if (history.length > _maxItems) {
      history.removeLast();
    }

    await prefs.setStringList(_key, history);
  }

  Future<List<String>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }
}
