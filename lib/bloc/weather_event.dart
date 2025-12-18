sealed class WeatherEvent {}

class WeatherFetched extends WeatherEvent {
  final String cityName;

  WeatherFetched(this.cityName);
}

class WeatherRefreshRequested extends WeatherEvent {}

class WeatherThemeToggled extends WeatherEvent {}

class WeatherUnitToggled extends WeatherEvent {}
