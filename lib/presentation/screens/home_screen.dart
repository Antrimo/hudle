import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hudle/bloc/weather_bloc.dart';
import 'package:hudle/bloc/weather_event.dart';
import 'package:hudle/bloc/weather_state.dart';
import 'package:hudle/core/utils/weather_cases.dart';
import 'package:hudle/data/local/weather_history_local.dart';
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
  void _openSearchPopup() async {
    final controller = TextEditingController();
    final historyHelper = WeatherHistoryLocal();
    final history = await historyHelper.loadHistory();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search your city'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Enter city name...',
                  ),
                ),

                if (history.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Recent searches',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final city = history[index];
                        return ListTile(
                          leading: const Icon(Icons.history),
                          title: Text(city),
                          onTap: () {
                            controller.text = city;
                            _submitSearch(controller, historyHelper);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => _submitSearch(controller, historyHelper),
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  // function to handle search submission
  void _submitSearch(
    TextEditingController controller,
    WeatherHistoryLocal historyHelper,
  ) {
    final city = controller.text.trim();
    if (city.isEmpty) return;

    historyHelper.saveCity(city);

    context.read<WeatherBloc>().add(WeatherFetched(city));
    Navigator.pop(context);
  }

  // Convert temperature based on selected unit
  double _displayTemp(double temp, bool isCelsius) {
    return isCelsius ? temp : (temp * 9 / 5) + 32;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuWidget(),
      appBar: AppBar(
        backgroundColor: Colors.grey[500],
        foregroundColor: Colors.black,
        title: Text(
          'Weather',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _openSearchPopup,
            tooltip: 'Search city',
          ),
        ],
        centerTitle: true,
      ),
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
                    color: Colors.grey.shade500,
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 32,
                      ),
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        Row(
                          textBaseline: TextBaseline.ideographic,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              weather.cityName,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    height: 1.2,
                                    letterSpacing: 0.2,
                                  ),
                            ),

                            const SizedBox(width: 8),
                            Icon(
                              Icons.location_pin,
                              color: Theme.of(context).iconTheme.color,
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
                              style: Theme.of(context).textTheme.displayLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    height: 1.0,
                                    letterSpacing: -1,
                                  ),
                            ),

                            const SizedBox(width: 16),
                            Text(
                              weather.weatherCondition,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    height: 1.4,
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.color,
                                  ),
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

                // Display error message if fetching weather fails
                if (state is WeatherFailure) {
                  return Center(
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.redAccent,
                        height: 1.4,
                      ),
                    ),
                  );
                }

                // Default state for user to search for a city
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/default.json',
                        height: 200,
                        repeat: true,
                      ),
                      Text(
                        'Search for a city to get weather details',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                          color: Theme.of(context).hintColor,
                        ),
                        textAlign: TextAlign.center,
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
