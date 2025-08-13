import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherController with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  WeatherModel? _currentWeather;
  bool _isLoading = false;
  String? _error;

  WeatherModel? get currentWeather => _currentWeather;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchWeatherByCity(String city) async {
    _isLoading = true;
    notifyListeners();

    try {
      final weatherData = await _weatherService.getWeatherByCity(city);
      _currentWeather = WeatherModel.fromJson(weatherData);
      _error = null;
    } catch (e) {
      _error = 'Failed to fetch weather: ${e.toString()}';
      _currentWeather = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWeatherByLocation(double lat, double lon) async {
    _isLoading = true;
    notifyListeners();

    try {
      final weatherData = await _weatherService.getWeatherByLocation(lat, lon);
      _currentWeather = WeatherModel.fromJson(weatherData);
      _error = null;
    } catch (e) {
      _error = 'Failed to fetch weather: ${e.toString()}';
      _currentWeather = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}