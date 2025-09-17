import 'package:flutter/material.dart';
import '../controllers/scan_controller.dart';
import '../models/scan_result.dart';

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
    await _controller.saveScan(result);
    setState(() {
      _latest = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Microplastic Detection")),
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
                Text("Concentration: ${_latest!.concentration.toStringAsFixed(2)} ppm"),
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
