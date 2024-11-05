import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'dart:async';

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
  final LatLng defaultLocation =
      const LatLng(35.6895, 139.6917); // Tokyo coordinates
  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    _checkAndRequestLocationPermission();
  }

  // 現在位置を取得
  Future<LatLng> getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }

  // 位置情報のパーミッションと設定を確認
  Future<void> _checkAndRequestLocationPermission() async {
    final locationResult = await checkLocationSetting();
    if (locationResult != LocationSettingResult.enabled) {
      await recoverLocationSettings(context, locationResult);
    }
  }

  // マップ作成時の処理
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map'),
      ),
      body: FutureBuilder<LatLng>(
        future: getCurrentLocation(),
        builder: (BuildContext context, AsyncSnapshot<LatLng> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: snapshot.data ?? defaultLocation,
              zoom: 17.0,
            ),
            myLocationEnabled: true,
            onMapCreated: _onMapCreated,
          );
        },
      ),
    );
  }
}

// LocationSettingResult の定義
enum LocationSettingResult {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  enabled,
}

// 位置情報パーミッションと設定の確認
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

// 位置設定のリカバリ処理
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
