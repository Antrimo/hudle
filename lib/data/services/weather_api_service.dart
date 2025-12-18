import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../models/weather_model.dart';

// Service to fetch weather data from OpenWeatherMap API

class WeatherApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  Future<WeatherModel> fetchWeather(String cityName) async {
    try {
      final response = await dio.get(
        '/weather',
        queryParameters: {
          'q': cityName,
          'appid': ApiConstants.apiKey,
          'units': 'metric',
        },
      );

      return WeatherModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw 'No internet connection';
      }
      throw 'Failed to fetch weather data';
    } catch (_) {
      throw 'Unexpected error occurred';
    }
  }
}
