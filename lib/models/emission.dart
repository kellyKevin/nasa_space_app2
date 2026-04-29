class Emission {
  final String location;
  final double latitude;
  final double longitude;
  final double emissions;

  Emission({
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.emissions,
  });

  factory Emission.fromJson(Map<String, dynamic> json) {
    if (json['location'] == null || json['coordinates'] == null) {
      throw FormatException('Invalid JSON for Emission');
    }
    var coords = json['coordinates'] as List;
    return Emission(
      location: json['location'] as String,
      latitude: coords[0].toDouble(),
      longitude: coords[1].toDouble(),
      emissions: json['emissions'] is num
        ? (json['emissions'] as num).toDouble()
        : double.tryParse(json['emissions'].toString().split(' ')[0]) ?? 0.0,
    );
  }
}
