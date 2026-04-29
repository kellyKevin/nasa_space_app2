import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_space_app2/models/emission.dart';
import 'dart:convert';

void main() {
  group('Emission Model Tests', () {
    test('should parse emission from json', () {
      final jsonString = '{"location": "Test City", "emissions": 100.5, "coordinates": [10.0, 20.0]}';
      final jsonMap = json.decode(jsonString);
      final emission = Emission.fromJson(jsonMap);

      expect(emission.location, 'Test City');
      expect(emission.emissions, 100.5);
      expect(emission.latitude, 10.0);
      expect(emission.longitude, 20.0);
    });

    test('should parse emission from json with string emissions', () {
      final jsonString = '{"location": "Test City", "emissions": "150 ppm", "coordinates": [10.0, 20.0]}';
      final jsonMap = json.decode(jsonString);
      final emission = Emission.fromJson(jsonMap);

      expect(emission.location, 'Test City');
      expect(emission.emissions, 150.0);
    });

    test('should throw FormatException for invalid json', () {
      final jsonString = '{"location": "Test City"}';
      final jsonMap = json.decode(jsonString);

      expect(() => Emission.fromJson(jsonMap), throwsFormatException);
    });
  });
}
