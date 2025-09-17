import 'package:flutter/material.dart';
import '../controllers/scan_controller.dart';
import '../models/scan_result.dart';

class HistoryScreen extends StatelessWidget {
  final ScanController _controller = ScanController();

  HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan History")),
      body: StreamBuilder<List<ScanResult>>(
        stream: _controller.getScans(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final scans = snapshot.data!;
          if (scans.isEmpty) return const Center(child: Text("No scans yet."));
          return ListView.builder(
            itemCount: scans.length,
            itemBuilder: (context, index) {
              final scan = scans[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text("${scan.type} (${scan.pollutionLevel})"),
                  subtitle: Text(
                      "Concentration: ${scan.concentration.toStringAsFixed(2)} ppm\nTime: ${scan.timestamp.toLocal()}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
