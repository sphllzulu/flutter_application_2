import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_2/models/venue_model.dart';

class FoursquareService {
  static const String _apiKey = 'fsq3FJE606eIX1i+78mXtq81xVa5XMzxxc1yeI1zB5yEp74=';
  static const String _apiUrl = 'https://api.foursquare.com/v3/places/search';

  Future<List<Venue>> getRecommendations(double lat, double lng, double temp) async {
    try {
      final category = _getCategoryForTemperature(temp);
      final response = await http.get(
        Uri.parse('$_apiUrl?ll=$lat,$lng&categories=$category&limit=5'),
        headers: {
          'Accept': 'application/json',
          'Authorization': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List?;
        if (results == null) return [];
        
        return results
            .where((json) => json != null)
            .map((json) => Venue.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load recommendations: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('API request failed: $e');
    }
  }

  String _getCategoryForTemperature(double temp) {
    if (temp > 30) return '13000'; // Beach/pool
    if (temp > 20) return '16000'; // Outdoor recreation
    if (temp > 10) return '13027'; // Coffee shop
    return '13032'; // Indoor activities
  }
}