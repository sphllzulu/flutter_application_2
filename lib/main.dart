import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'controllers/weather_controller.dart';
import 'models/weather_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WeatherController(),
      child: const WeatherApp(),
    ),
  );
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocationWeather();
  }

  Future<void> _getCurrentLocationWeather() async {
    final status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
    
    final position = await Geolocator.getCurrentPosition();
    final controller = Provider.of<WeatherController>(context, listen: false);
    await controller.fetchWeatherByLocation(
      position.latitude,
      position.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<WeatherController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Enter city',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    await controller.fetchWeatherByCity(_cityController.text);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (controller.isLoading)
              const CircularProgressIndicator()
            else if (controller.error != null)
              Text(controller.error!)
            else if (controller.currentWeather != null)
              _buildWeatherCard(controller.currentWeather!)
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherCard(WeatherModel weather) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(weather.city, style: const TextStyle(fontSize: 24)),
            Image.network(weather.weatherIcon),
            Text('${weather.temperature}°C', style: const TextStyle(fontSize: 48)),
            Text(weather.description),
            Text('Humidity: ${weather.humidity}%'),
            Text('Wind: ${weather.windSpeed} km/h'),
          ],
        ),
      ),
    );
  }
}
