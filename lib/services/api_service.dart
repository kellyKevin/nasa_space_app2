import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import '../models/emission.dart';

class ApiService {
  // Use localhost for local development, adjust if needed
  static const String apiUrl = 'http://127.0.0.1:5000/api/emissions';

  Future<List<Emission>> fetchEmissions() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => Emission.fromJson(item)).toList();
      } else {
        print('Failed to load from API: ${response.statusCode}');
        return _loadFromAssets();
      }
    } catch (e) {
      print('Error fetching from API: $e');
      return _loadFromAssets();
    }
  }

  Future<List<Emission>> _loadFromAssets() async {
    try {
      final String response = await rootBundle.loadString('assets/emissions_data.json');
      final data = jsonDecode(response);
      List<dynamic> body = data;
      // Filter out empty objects if any
      return body
          .where((item) => item['location'] != null)
          .map((dynamic item) => Emission.fromJson(item))
          .toList();
    } catch (e) {
      print('Error loading from assets: $e');
      return [];
    }
  }
}
