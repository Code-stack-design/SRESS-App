class SensorLocation {
  final String id;
  final String location;
  final double lat;
  final double lng;
  bool leakage;
  String timestamp;

  SensorLocation({
    required this.id,
    required this.location,
    required this.lat,
    required this.lng,
    required this.leakage,
    required this.timestamp,
  });
}
