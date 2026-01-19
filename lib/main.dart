import 'package:flutter/material.dart';
import 'mqtt_service.dart';
import 'sensor_location.dart';
import 'map_screen.dart';

void main() {
  runApp(const SRESSApp());
}

class SRESSApp extends StatefulWidget {
  const SRESSApp({super.key});

  @override
  State<SRESSApp> createState() => _SRESSAppState();
}

class _SRESSAppState extends State<SRESSApp> {
  final mqtt = MQTTService();
  List<SensorLocation> sensors = [];

  @override
  void initState() {
    super.initState();
    mqtt.connect((data) {
      setState(() {
        // Extract sample (assuming location="Pole-23, Sector 11", lat, lng exist)
        String id = data['id'];
        int index = sensors.indexWhere((s) => s.id == id);

        if (index >= 0) {
          sensors[index].leakage = data['leakage'];
          sensors[index].timestamp = data['timestamp'];
        } else {
          sensors.add(SensorLocation(
            id: id,
            location: data['location'],
            lat: data['lat'],
            lng: data['lng'],
            leakage: data['leakage'],
            timestamp: data['timestamp'],
          ));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SRESS Dashboard',
      home: Scaffold(
        appBar: AppBar(
          title: const Text("SRESS Dashboard"),
          actions: [
            IconButton(
              icon: const Icon(Icons.map),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MapScreen(sensors: sensors),
                  ),
                );
              },
            )
          ],
        ),
        body: sensors.isEmpty
            ? const Center(child: Text("Waiting for data..."))
            : ListView.builder(
                itemCount: sensors.length,
                itemBuilder: (context, i) {
                  final s = sensors[i];
                  return ListTile(
                    title: Text(s.location),
                    subtitle: Text("Status: ${s.leakage ? 'Leakage' : 'Safe'}"),
                    trailing: Icon(
                      s.leakage ? Icons.warning : Icons.check,
                      color: s.leakage ? Colors.red : Colors.green,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
