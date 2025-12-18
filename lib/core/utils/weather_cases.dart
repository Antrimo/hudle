// Maps weather conditions to its corresponding animation asset

class WeatherAnimationMapper {
  static String getAnimation(String condition) {
    final weather = condition.toLowerCase();

    if (weather.contains('clear')) {
      return 'assets/lottie/sunny.json';
    } else if (weather.contains('cloud')) {
      return 'assets/lottie/cloudy.json';
    } else if (weather.contains('rain') || weather.contains('drizzle')) {
      return 'assets/lottie/rainy.json';
    } else if (weather.contains('thunder')) {
      return 'assets/lottie/thunder.json';
    } else if (weather.contains('snow')) {
      return 'assets/lottie/snow.json';
    } else if (weather.contains('wind')) {
      return 'assets/lottie/wind.json';
    } else if (weather.contains('mist') ||
        weather.contains('haze') ||
        weather.contains('fog')) {
      return 'assets/lottie/haze.json';
    }

    return 'assets/lottie/sunny.json'; // fallback
  }
}
