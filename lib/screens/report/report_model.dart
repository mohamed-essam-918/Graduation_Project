import 'package:intl/intl.dart';

class MedicalReport {
  final String id;
  final DateTime createdAt;
  final String diseaseType;
  final List<String> medications;
  final Map<String, int> medicationQuantities;
  final String treatmentDetails;

  MedicalReport({
    String? id,
    DateTime? createdAt,
    required this.diseaseType,
    required this.medications,
    required this.medicationQuantities,
    required this.treatmentDetails,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'diseaseType': diseaseType,
      'medications': medications,
      'medicationQuantities': medicationQuantities,
      'treatmentDetails': treatmentDetails,
    };
  }

  factory MedicalReport.fromJson(Map<String, dynamic> json) {
    return MedicalReport(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      diseaseType: json['diseaseType'],
      medications: List<String>.from(json['medications']),
      medicationQuantities: Map<String, int>.from(json['medicationQuantities']),
      treatmentDetails: json['treatmentDetails'],
    );
  }
}
