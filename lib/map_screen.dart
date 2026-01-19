import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'sensor_location.dart';

class MapScreen extends StatefulWidget {
  final List<SensorLocation> sensors;
  const MapScreen({super.key, required this.sensors});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = widget.sensors.map((sensor) {
      return Marker(
        markerId: MarkerId(sensor.id),
        position: LatLng(sensor.lat, sensor.lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            sensor.leakage ? BitmapDescriptor.hueRed : BitmapDescriptor.hueGreen
        ),
        infoWindow: InfoWindow(
          title: sensor.location,
          snippet: sensor.leakage 
            ? "⚠ Leakage Detected at ${sensor.timestamp}" 
            : "✔ Safe at ${sensor.timestamp}",
        ),
      );
    }).toSet();

    return Scaffold(
      appBar: AppBar(title: const Text("SRESS Map View")),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(28.6139, 77.2090), // default Delhi
          zoom: 13,
        ),
        markers: markers,
        onMapCreated: (controller) {
          mapController = controller;
        },
      ),
    );
  }
}
