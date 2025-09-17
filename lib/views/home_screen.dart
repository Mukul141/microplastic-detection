import 'package:flutter/material.dart';
import '../controllers/scan_controller.dart';
import '../models/scan_result.dart';
import 'map_screen.dart'; // Import the map screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScanController _controller = ScanController();
  ScanResult? _latest;

  void _simulate() async {
    final result = _controller.simulateScan();

    // Added error handling to see issues in the debug console
    try {
      await _controller.saveScan(result);
      print("✅ Scan successfully saved to Firestore!");
      setState(() {
        _latest = result;
      });
    } catch (e) {
      print("🚨 Error saving to Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Microplastic Detection"),
        // Added an actions list with an IconButton
        actions: [
          IconButton(
            icon: const Icon(Icons.map_outlined),
            tooltip: 'Open Pollution Map',
            onPressed: () {
              // This code navigates to the MapScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MapScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: _latest == null
            ? const Text("No scan yet. Tap the button below.")
            : Card(
          elevation: 4,
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Type: ${_latest!.type}",
                    style: const TextStyle(fontSize: 20)),
                Text("Pollution Level: ${_latest!.pollutionLevel}"),
                Text(
                    "Concentration: ${_latest!.concentration.toStringAsFixed(2)} ppm"),
                Text("Time: ${_latest!.timestamp.toLocal()}"),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _simulate,
        child: const Icon(Icons.science),
      ),
    );
  }
}