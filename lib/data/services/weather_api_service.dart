import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../models/weather_model.dart';

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
      print(response.data);
      return WeatherModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection found');
      }
      throw Exception('Something went wrong');
    } catch (e) {
      throw Exception('Unexpected error occurred');
    }
  }
}
