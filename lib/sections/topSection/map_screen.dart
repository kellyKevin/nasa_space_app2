import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/emission.dart';
import '../../services/api_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final ApiService _apiService = ApiService();

  final LatLng _center = const LatLng(20.0, 0.0); // Center the map more globally

  Map<MarkerId, Marker> markers = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEmissionData();
  }

  Future<void> _loadEmissionData() async {
    List<Emission> emissions = await _apiService.fetchEmissions();

    for (var emission in emissions) {
      _addMarker(
        LatLng(emission.latitude, emission.longitude),
        emission.location,
        BitmapDescriptor.defaultMarkerWithHue(
          _getHueForEmissions(emission.emissions)
        ),
        "Emissions: ${emission.emissions} tons CO2",
      );
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  double _getHueForEmissions(double emissions) {
    if (emissions > 800) return BitmapDescriptor.hueRed;
    if (emissions > 500) return BitmapDescriptor.hueOrange;
    if (emissions > 0) return BitmapDescriptor.hueYellow;
    return BitmapDescriptor.hueGreen;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 2,
              ),
              myLocationEnabled: false,
              tiltGesturesEnabled: true,
              compassEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              onMapCreated: _onMapCreated,
              markers: Set<Marker>.of(markers.values),
            ),
            if (isLoading)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _addMarker(LatLng position, String id, BitmapDescriptor descriptor, String info) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      icon: descriptor,
      position: position,
      infoWindow: InfoWindow(
        title: id,
        snippet: info,
      ),
    );
    markers[markerId] = marker;
  }

  @override
  void dispose() {
    // Controller disposal is handled by the map widget internally if not explicitly managed,
    // but keeping it for completeness if needed.
    super.dispose();
  }
}
