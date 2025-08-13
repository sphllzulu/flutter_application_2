import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import 'package:flutter_application_2/models/venue_model.dart';
import '../services/weather_service.dart';
import '../services/foursquare_service.dart';

class WeatherController with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final FoursquareService _foursquareService = FoursquareService();
  
  WeatherModel? _currentWeather;
  bool _isLoading = false;
  bool _isLoadingRecommendations = false;
  String? _error;
  String? _recommendationsError;
  List<Venue> _recommendations = [];

  WeatherModel? get currentWeather => _currentWeather;
  bool get isLoading => _isLoading;
  bool get isLoadingRecommendations => _isLoadingRecommendations;
  String? get error => _error;
  String? get recommendationsError => _recommendationsError;
  List<Venue> get recommendations => _recommendations;

  Future<void> fetchWeatherByCity(String city) async {
    _isLoading = true;
    _isLoadingRecommendations = true;
    notifyListeners();

    try {
      final weatherData = await _weatherService.getWeatherByCity(city);
      _currentWeather = WeatherModel.fromJson(weatherData);
      _error = null;
      
      if (_currentWeather != null) {
        await _fetchRecommendations(
          _currentWeather!.latitude,
          _currentWeather!.longitude,
          _currentWeather!.temperature
        );
      }
    } catch (e) {
      _error = 'Failed to fetch weather: ${e.toString()}';
      _currentWeather = null;
    } finally {
      _isLoading = false;
      _isLoadingRecommendations = false;
      notifyListeners();
    }
  }

  Future<void> _fetchRecommendations(double lat, double lng, double temp) async {
    try {
      _recommendations = await _foursquareService.getRecommendations(lat, lng, temp);
      _recommendationsError = null;
    } catch (e) {
      _recommendationsError = 'Failed to load recommendations: ${e.toString()}';
      _recommendations = [];
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