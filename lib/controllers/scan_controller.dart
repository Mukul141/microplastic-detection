import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/scan_result.dart';

class ScanController {
  final _db = FirebaseFirestore.instance;
  final _random = Random();

  // Simulate fake data including location
  ScanResult simulateScan() {
    final types = ["PET", "PVC", "PE", "PP", "None"];
    final pollutionLevels = ["Low", "Medium", "High"];

    String type = types[_random.nextInt(types.length)];
    double concentration = type == "None" ? 0 : _random.nextDouble() * 50;

    String pollutionLevel;
    if (concentration == 0) {
      pollutionLevel = "None";
    } else if (concentration < 15) {
      pollutionLevel = "Low";
    } else if (concentration < 30) {
      pollutionLevel = "Medium";
    } else {
      pollutionLevel = "High";
    }

    // --- Generate Random Location Data ---
    // Coordinates for Chennai, India: ~13.0827° N, 80.2707° E
    const double baseLatitude = 13.0827;
    const double baseLongitude = 80.2707;

    // Generate a random offset within ~5-10km
    final double latOffset = (_random.nextDouble() - 0.5) * 0.1; // Approx +/- 5.5 km
    final double lonOffset = (_random.nextDouble() - 0.5) * 0.1; // Approx +/- 5.5 km

    final double latitude = baseLatitude + latOffset;
    final double longitude = baseLongitude + lonOffset;
    // --- End of Location Generation ---


    return ScanResult(
      type: type,
      pollutionLevel: pollutionLevel,
      concentration: concentration,
      timestamp: DateTime.now(),
      latitude: latitude,
      longitude: longitude,
    );
  }

  // Save to Firestore
  Future<void> saveScan(ScanResult scan) async {
    await _db.collection('scans').add(scan.toJson());
  }

  // Stream from Firestore
  Stream<List<ScanResult>> getScans() {
    return _db
        .collection('scans')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ScanResult.fromJson(doc.data()))
        .toList());
  }
}