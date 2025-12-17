import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hudle/bloc/weather_bloc.dart';
import 'package:hudle/bloc/weather_event.dart';
import 'package:hudle/bloc/weather_state.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Settings',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),

            BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, state) {
                bool isDark = false;
                bool isCelsius = true;

                if (state is WeatherSuccess) {
                  isDark = state.isDarkMode;
                  isCelsius = state.isCelsius;
                }

                return Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Dark Mode'),
                      value: isDark,
                      onChanged: (_) {
                        context.read<WeatherBloc>().add(WeatherThemeToggled());
                      },
                      secondary: const Icon(Icons.dark_mode),
                    ),
                    SwitchListTile(
                      title: const Text('Temperature Unit'),
                      subtitle: Text(
                        isCelsius ? 'Celsius (°C)' : 'Fahrenheit (°F)',
                      ),
                      value: isCelsius,
                      onChanged: (_) {
                        context.read<WeatherBloc>().add(WeatherUnitToggled());
                      },
                      secondary: const Icon(Icons.thermostat),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
