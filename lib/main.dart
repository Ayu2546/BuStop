import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(35.6895, 139.6917); // Tokyo
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _fetchLocationData();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _fetchLocationData() async {
    // Replace with your actual API endpoint
    final url = Uri.parse('https://example.com/locations');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;

        setState(() {
          for (var location in data) {
            final LatLng position = LatLng(
              location['latitude'],
              location['longitude'],
            );
            _markers.add(
              Marker(
                markerId: MarkerId(location['id'].toString()),
                position: position,
                infoWindow: InfoWindow(title: location['name']),
              ),
            );
          }
        });
      } else {
        throw Exception('Failed to load locations');
      }
    } catch (e) {
      print("Error fetching locations: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map with HTTP'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: _markers,
      ),
    );
  }
}
