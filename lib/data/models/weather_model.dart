class WeatherModel {
  final String cityName;
  final double temperature;
  final String weatherCondition;
  final int humidity;
  final double windSpeed;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.weatherCondition,
    required this.humidity,
    required this.windSpeed,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      temperature: (json['main']['temp'] as num).toDouble(),
      weatherCondition: json['weather'][0]['main'],
      humidity: json['main']['humidity'],
      windSpeed: (json['wind']['speed'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'temperature': temperature,
      'weatherCondition': weatherCondition,
      'humidity': humidity,
      'windSpeed': windSpeed,
    };
  }

  factory WeatherModel.fromCache(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['cityName'],
      temperature: json['temperature'],
      weatherCondition: json['weatherCondition'],
      humidity: json['humidity'],
      windSpeed: json['windSpeed'],
    );
  }
}
