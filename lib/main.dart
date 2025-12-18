import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hudle/bloc/weather_bloc.dart';
import 'package:hudle/bloc/weather_state.dart';
import 'package:hudle/data/local/weather_cache.dart';
import 'package:hudle/data/repository/weather_repository.dart';
import 'package:hudle/data/services/weather_api_service.dart';
import 'package:hudle/presentation/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => WeatherRepository(WeatherApiService(), WeatherCache()),
      child: BlocProvider(
        create: (context) => WeatherBloc(context.read<WeatherRepository>()),
        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            bool isDark = false;

            if (state is WeatherSuccess) {
              isDark = state.isDarkMode;
            }
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: const HomeScreen(),
              theme: isDark ? ThemeData.dark() : ThemeData.light(),
            );
          },
        ),
      ),
    );
  }
}
