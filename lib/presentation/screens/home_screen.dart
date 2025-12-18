import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hudle/bloc/weather_bloc.dart';
import 'package:hudle/bloc/weather_event.dart';
import 'package:hudle/bloc/weather_state.dart';
import 'package:hudle/core/utils/weather_cases.dart';
import 'package:hudle/presentation/widgets/menu_widget.dart';
import 'package:hudle/presentation/widgets/tile_widget.dart';
import 'package:liquid_pull_refresh/liquid_pull_refresh.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _openSearchPopup() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search your city'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter city name'),
            onSubmitted: (_) => _submitSearch(controller),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => _submitSearch(controller),
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  void _submitSearch(TextEditingController controller) {
    final city = controller.text.trim();
    if (city.isNotEmpty) {
      context.read<WeatherBloc>().add(WeatherFetched(city));
    }
    Navigator.pop(context);
  }

  double _displayTemp(double temp, bool isCelsius) {
    return isCelsius ? temp : (temp * 9 / 5) + 32;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      drawer: const MenuWidget(),
      appBar: AppBar(title: const Text('weather app'), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, state) {
                if (state is WeatherLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is WeatherSuccess) {
                  final weather = state.weather;

                  return LiquidPullRefresh(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                    showChildOpacityTransition: true,
                    height: 80,
                    animSpeedFactor: 2,
                    onRefresh: () {
                      context.read<WeatherBloc>().add(
                        WeatherRefreshRequested(),
                      );
                      return Future.delayed(const Duration(milliseconds: 100));
                    },
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        Row(
                          textBaseline: TextBaseline.ideographic,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              weather.cityName,
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.location_pin,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            const Spacer(),
                            IconButton(
                              icon: Icon(
                                Icons.search,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              onPressed: _openSearchPopup,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          textBaseline: TextBaseline.alphabetic,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: [
                            Text(
                              '${_displayTemp(weather.temperature, state.isCelsius).toStringAsFixed(1)}°'
                              '${state.isCelsius ? 'C' : 'F'}',
                              style: const TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              weather.weatherCondition,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: SizedBox(
                            height: 350,
                            child: Lottie.asset(
                              WeatherAnimationMapper.getAnimation(
                                weather.weatherCondition,
                              ),
                              repeat: true,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TileWidget(
                              label: 'Humidity',
                              value: '${weather.humidity}%',
                              icon: Icons.water_drop,
                            ),
                            SizedBox(width: 16),
                            TileWidget(
                              label: 'Wind',
                              value: '${weather.windSpeed} m/s',
                              icon: Icons.air,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }

                if (state is WeatherFailure) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/default.json',
                        height: 200,
                        repeat: true,
                      ),
                      const Text(
                        'Search for a city to get weather details',
                        style: TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _openSearchPopup,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
