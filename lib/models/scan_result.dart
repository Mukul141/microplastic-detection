import 'package:cloud_firestore/cloud_firestore.dart';

class ScanResult {
  final String type;
  final String pollutionLevel;
  final double concentration;
  final DateTime timestamp;
  final double latitude; // Add this
  final double longitude; // Add this

  ScanResult({
    required this.type,
    required this.pollutionLevel,
    required this.concentration,
    required this.timestamp,
    required this.latitude, // Add this
    required this.longitude, // Add this
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'pollutionLevel': pollutionLevel,
      'concentration': concentration,
      'timestamp': timestamp.toIso8601String(),
      'latitude': latitude, // Add this
      'longitude': longitude, // Add this
    };
  }

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      type: json['type'],
      pollutionLevel: json['pollutionLevel'],
      concentration: (json['concentration'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
      latitude: (json['latitude'] as num).toDouble(), // Add this
      longitude: (json['longitude'] as num).toDouble(), // Add this
    );
  }
}