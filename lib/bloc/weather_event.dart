sealed class WeatherEvent {}

class WeatherFetched extends WeatherEvent {
  final String cityName;

  WeatherFetched(this.cityName);
}

class WeatherRefreshRequested extends WeatherEvent {}

class WeatherThemeChanged extends WeatherEvent {
  final bool isDarkMode;

  WeatherThemeChanged(this.isDarkMode);
}
