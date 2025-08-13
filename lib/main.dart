import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'controllers/weather_controller.dart';
import 'models/weather_model.dart';
import 'package:flutter_application_2/models/venue_model.dart';

Future<void> main() async {
  try {
    
    runApp(
      ChangeNotifierProvider(
        create: (context) => WeatherController(),
        child: const WeatherApp(),
      ),
    );
  } catch (e, stackTrace) {
    print('Error during app initialization: $e');
    print(stackTrace);
    rethrow;
  }
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black87,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
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
      appBar: AppBar(
        title: const Text('Weather App'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[400]!, Colors.blue[600]!],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
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
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  if (controller.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (controller.error != null)
                    Center(child: Text(controller.error!))
                  else if (controller.currentWeather != null) ...[
                    _buildWeatherCard(controller.currentWeather!),
                    _buildRecommendationsSection(context),
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCard(WeatherModel weather) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(weather.city,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )),
            const SizedBox(height: 8),
            Image.network(weather.weatherIcon, height: 100),
            const SizedBox(height: 16),
            Text('${weather.temperature}°C',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              )),
            const SizedBox(height: 8),
            Text(weather.description,
              style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [
                  const Text('Humidity'),
                  Text('${weather.humidity}%'),
                ]),
                Column(children: [
                  const Text('Wind'),
                  Text('${weather.windSpeed} km/h'),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsSection(BuildContext context) {
    final controller = Provider.of<WeatherController>(context);
    
    if (controller.isLoadingRecommendations) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.recommendationsError != null) {
      return Text(controller.recommendationsError!);
    }

    if (controller.recommendations.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 24, bottom: 8),
          child: Text('Recommended Places',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
        ),
        ...controller.recommendations.map((venue) =>
          _buildVenueCard(venue)).toList(),
      ],
    );
  }

  Widget _buildVenueCard(Venue venue) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            if (venue.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  venue.imageUrl!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(venue.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                  Text(venue.category),
                  Text('${venue.distance.toStringAsFixed(1)} km away'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
