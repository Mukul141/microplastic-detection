class ScanResult {
  final String type;
  final String pollutionLevel; // e.g., Low, Medium, High
  final double concentration;
  final DateTime timestamp;

  ScanResult({
    required this.type,
    required this.pollutionLevel,
    required this.concentration,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'pollutionLevel': pollutionLevel,
      'concentration': concentration,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      type: json['type'],
      pollutionLevel: json['pollutionLevel'],
      concentration: (json['concentration'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
