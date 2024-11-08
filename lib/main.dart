import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'database.dart';

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
  final LatLng defaultLocation = const LatLng(37.4878198, 139.9296658);
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _currentPosition;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initLocationService();
  }

  Future<void> _initLocationService() async {
    final locationResult = await checkLocationSetting();
    if (locationResult == LocationSettingResult.enabled) {
      await _getCurrentLocation();
    } else {
      await recoverLocationSettings(context, locationResult);
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
      _moveToCurrentLocation();
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _moveToCurrentLocation() {
    if (_currentPosition != null) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition!, zoom: 17),
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _controller.complete(controller);
  }

  Future<void> _searchAndNavigate() async {
    String searchQuery = _searchController.text;
    if (searchQuery.isEmpty) return;

    final apiKey = 'AIzaSyB3WzJiraDNM_hDGe9M_f1-bjzgSry53nc';
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$searchQuery&key=$apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          LatLng searchedLocation = LatLng(location['lat'], location['lng']);
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: searchedLocation, zoom: 15),
            ),
          );
        } else {
          print("No results found for the search.");
        }
      } else {
        print("Failed to fetch location data.");
      }
    } catch (e) {
      print("Error searching location: $e");
    }
  }

  void _zoomIn() {
    mapController.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    mapController.animateCamera(CameraUpdate.zoomOut());
  }

  Future<void> _showBusSchedulePopup() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    List<Map<String, dynamic>> schedule = await dbHelper.getBusSchedule();

    List<String> busTimes =
        schedule.map((item) => item['departureTime'].toString()).toList();

    showOkAlertDialog(
      context: context,
      title: 'Bus Schedule',
      message: busTimes.join('\n'),
    );
  }

  Set<Marker> _createMarker() {
    return {
      Marker(
        markerId: MarkerId('busScheduleMarker'),
        position: LatLng(37.5076457, 139.9318131),
        infoWindow: InfoWindow(
          title: 'Bus Schedule',
          onTap: _showBusSchedulePopup,
        ),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search location',
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: _searchAndNavigate,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: _currentPosition ?? defaultLocation,
              zoom: 15.0,
            ),
            myLocationEnabled: true,
            onMapCreated: _onMapCreated,
            markers: _createMarker(),
          ),
          Positioned(
            right: 10,
            bottom: 80,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: _zoomIn,
                  child: Icon(Icons.zoom_in),
                  mini: true,
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: _zoomOut,
                  child: Icon(Icons.zoom_out),
                  mini: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum LocationSettingResult {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  enabled,
}

Future<LocationSettingResult> checkLocationSetting() async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    print('Location services are disabled.');
    return LocationSettingResult.serviceDisabled;
  }

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied.');
      return LocationSettingResult.permissionDenied;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    print('Location permissions are permanently denied.');
    return LocationSettingResult.permissionDeniedForever;
  }

  return LocationSettingResult.enabled;
}

Future<void> recoverLocationSettings(
    BuildContext context, LocationSettingResult locationResult) async {
  if (locationResult == LocationSettingResult.enabled) {
    return;
  }

  final result = await showOkCancelAlertDialog(
    context: context,
    okLabel: 'OK',
    cancelLabel: 'キャンセル',
    title: 'Location Settings',
    message: 'Please enable location services or permissions to continue.',
  );

  if (result == OkCancelResult.cancel) {
    print('User canceled recovery of location settings.');
  } else {
    locationResult == LocationSettingResult.serviceDisabled
        ? await Geolocator.openLocationSettings()
        : await Geolocator.openAppSettings();
  }
}
