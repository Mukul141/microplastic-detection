import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/scan_controller.dart';
import '../models/scan_result.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final ScanController _scanController = ScanController();

  // We no longer need the _markers state variable here

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(13.0827, 80.2707),
    zoom: 12.0,
  );

  // Helper function to build the set of markers from a list of scans
  Set<Marker> _buildMarkersFromScans(List<ScanResult> scans) {
    Set<Marker> markers = {};
    for (var scan in scans) {
      if (scan.pollutionLevel == "None") continue;

      markers.add(
        Marker(
          markerId: MarkerId(scan.timestamp.toIso8601String()),
          position: LatLng(scan.latitude, scan.longitude),
          infoWindow: InfoWindow(
            title: 'Plastic: ${scan.type}',
            snippet:
            'Level: ${scan.pollutionLevel} (${scan.concentration.toStringAsFixed(2)} ppm)',
          ),
          icon: _getColorForPollution(scan.pollutionLevel),
        ),
      );
    }
    return markers;
  }

  BitmapDescriptor _getColorForPollution(String pollutionLevel) {
    switch (pollutionLevel) {
      case 'High':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case 'Medium':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      case 'Low':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      default:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pollution Map"),
      ),
      body: StreamBuilder<List<ScanResult>>(
        stream: _scanController.getScans(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Show the map even if there are no markers yet
            return const GoogleMap(initialCameraPosition: _initialCameraPosition);
          }

          // Build the markers directly from the latest data
          final markers = _buildMarkersFromScans(snapshot.data!);

          return GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            markers: markers, // Pass the newly built markers
            mapType: MapType.normal,
          );
        },
      ),
    );
  }
}