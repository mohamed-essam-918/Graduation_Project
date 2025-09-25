import 'package:shared_preferences/shared_preferences.dart';

class AppData {
  final String? name;
  final DateTime? birthDate;
  final String? nationalId;
  final Map<String, bool> vaccinesStatus;

  AppData({
    this.name,
    this.birthDate,
    this.nationalId,
    required this.vaccinesStatus,
  });

  AppData copyWith({
    String? name,
    DateTime? birthDate,
    String? nationalId,
    Map<String, bool>? vaccinesStatus,
  }) {
    return AppData(
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      nationalId: nationalId ?? this.nationalId,
      vaccinesStatus: vaccinesStatus ?? this.vaccinesStatus,
    );
  }
}

class DataStorage {
  final SharedPreferences prefs;

  DataStorage(this.prefs);

  Future<AppData> loadData() async {
    try {
      return AppData(
        name: prefs.getString('name'),
        birthDate: _parseDate(prefs.getString('birthDate')),
        nationalId: prefs.getString('nationalId'),
        vaccinesStatus:
            _parseVaccinesStatus(prefs.getStringList('vaccinesStatus')),
      );
    } catch (e) {
      return AppData(vaccinesStatus: {});
    }
  }

  Future<void> saveData(AppData data) async {
    try {
      await prefs.setString('name', data.name ?? '');
      await prefs.setString(
          'birthDate', data.birthDate?.toIso8601String() ?? '');
      await prefs.setString('nationalId', data.nationalId ?? '');
      await prefs.setStringList(
        'vaccinesStatus',
        data.vaccinesStatus.entries.map((e) => '${e.key}:${e.value}').toList(),
      );
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  DateTime? _parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    return DateTime.tryParse(dateString);
  }

  Map<String, bool> _parseVaccinesStatus(List<String>? items) {
    final Map<String, bool> result = {};
    items?.forEach((item) {
      final parts = item.split(':');
      if (parts.length == 2) {
        result[parts[0]] = parts[1] == 'true';
      }
    });
    return result;
  }
}
