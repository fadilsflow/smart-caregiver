import 'dart:math';

class MockHealthRecords {
  static final Map<String, List<Map<String, dynamic>>> _recordsByPatient = {
    '1': _generateRecordsForPatient1(),
    '2': _generateRecordsForPatient2(),
    '3': _generateRecordsForPatient3(),
    '4': _generateRecordsForPatient4(),
  };

  static List<Map<String, dynamic>> _generateRecordsForPatient1() {
    return [
      {
        'id': '1-1',
        'patientId': '1',
        'date': '2026-05-09',
        'tensi': {'systolic': 130, 'diastolic': 85, 'status': 'Normal', 'color': 0xFF10B981},
        'suhu': {'value': 36.5, 'status': 'Normal', 'color': 0xFF10B981},
        'gulaDarah': {'value': 140, 'status': 'Normal', 'color': 0xFF10B981},
        'kolestrol': {'value': 190, 'status': 'Normal', 'color': 0xFF10B981},
        'asamUrat': {'value': 5.2, 'status': 'Normal', 'color': 0xFF10B981},
        'detakJantung': {'value': 72, 'status': 'Normal', 'color': 0xFF10B981},
        'saturasi': {'value': 98, 'status': 'Normal', 'color': 0xFF10B981},
        'beratBadan': {'value': 65.5, 'status': 'Normal', 'color': 0xFF10B981},
        'symptoms': [],
        'notes': 'Kondisi umum baik',
      },
      {
        'id': '1-2',
        'patientId': '1',
        'date': '2026-05-08',
        'tensi': {'systolic': 135, 'diastolic': 88, 'status': 'Normal', 'color': 0xFF10B981},
        'suhu': {'value': 36.6, 'status': 'Normal', 'color': 0xFF10B981},
        'gulaDarah': {'value': 145, 'status': 'Normal', 'color': 0xFF10B981},
        'kolestrol': {'value': 195, 'status': 'Normal', 'color': 0xFF10B981},
        'asamUrat': {'value': 5.5, 'status': 'Normal', 'color': 0xFF10B981},
        'detakJantung': {'value': 75, 'status': 'Normal', 'color': 0xFF10B981},
        'saturasi': {'value': 97, 'status': 'Normal', 'color': 0xFF10B981},
        'beratBadan': {'value': 65.8, 'status': 'Normal', 'color': 0xFF10B981},
        'symptoms': [],
        'notes': '',
      },
    ];
  }

  static List<Map<String, dynamic>> _generateRecordsForPatient2() {
    return [
      {
        'id': '2-1',
        'patientId': '2',
        'date': '2026-05-09',
        'tensi': {'systolic': 155, 'diastolic': 95, 'status': 'Perlu Perhatian', 'color': 0xFFF59E0B},
        'suhu': {'value': 37.2, 'status': 'Normal', 'color': 0xFF10B981},
        'gulaDarah': {'value': 180, 'status': 'Perlu Perhatian', 'color': 0xFFF59E0B},
        'kolestrol': {'value': 220, 'status': 'Perlu Perhatian', 'color': 0xFFF59E0B},
        'asamUrat': {'value': 7.2, 'status': 'Perlu Perhatian', 'color': 0xFFF59E0B},
        'detakJantung': {'value': 88, 'status': 'Normal', 'color': 0xFF10B981},
        'saturasi': {'value': 95, 'status': 'Normal', 'color': 0xFF10B981},
        'beratBadan': {'value': 72.0, 'status': 'Normal', 'color': 0xFF10B981},
        'symptoms': ['Batuk', 'Sesak Napas Ringan'],
        'notes': 'Periksa ulang minggu depan',
      },
      {
        'id': '2-2',
        'patientId': '2',
        'date': '2026-05-08',
        'tensi': {'systolic': 160, 'diastolic': 98, 'status': 'Perlu Perhatian', 'color': 0xFFF59E0B},
        'suhu': {'value': 37.0, 'status': 'Normal', 'color': 0xFF10B981},
        'gulaDarah': {'value': 175, 'status': 'Perlu Perhatian', 'color': 0xFFF59E0B},
        'kolestrol': {'value': 215, 'status': 'Perlu Perhatian', 'color': 0xFFF59E0B},
        'asamUrat': {'value': 7.0, 'status': 'Perlu Perhatian', 'color': 0xFFF59E0B},
        'detakJantung': {'value': 85, 'status': 'Normal', 'color': 0xFF10B981},
        'saturasi': {'value': 96, 'status': 'Normal', 'color': 0xFF10B981},
        'beratBadan': {'value': 72.2, 'status': 'Normal', 'color': 0xFF10B981},
        'symptoms': [],
        'notes': '',
      },
    ];
  }

  static List<Map<String, dynamic>> _generateRecordsForPatient3() {
    return [
      {
        'id': '3-1',
        'patientId': '3',
        'date': '2026-05-09',
        'tensi': {'systolic': 125, 'diastolic': 80, 'status': 'Normal', 'color': 0xFF10B981},
        'suhu': {'value': 36.4, 'status': 'Normal', 'color': 0xFF10B981},
        'gulaDarah': {'value': 110, 'status': 'Normal', 'color': 0xFF10B981},
        'kolestrol': {'value': 180, 'status': 'Normal', 'color': 0xFF10B981},
        'asamUrat': {'value': 4.8, 'status': 'Normal', 'color': 0xFF10B981},
        'detakJantung': {'value': 68, 'status': 'Normal', 'color': 0xFF10B981},
        'saturasi': {'value': 98, 'status': 'Normal', 'color': 0xFF10B981},
        'beratBadan': {'value': 55.0, 'status': 'Normal', 'color': 0xFF10B981},
        'symptoms': ['Nyeri Sendi'],
        'notes': 'Rutin minum obat arthritis',
      },
    ];
  }

  static List<Map<String, dynamic>> _generateRecordsForPatient4() {
    return [
      {
        'id': '4-1',
        'patientId': '4',
        'date': '2026-05-09',
        'tensi': {'systolic': 128, 'diastolic': 82, 'status': 'Normal', 'color': 0xFF10B981},
        'suhu': {'value': 36.5, 'status': 'Normal', 'color': 0xFF10B981},
        'gulaDarah': {'value': 135, 'status': 'Normal', 'color': 0xFF10B981},
        'kolestrol': {'value': 200, 'status': 'Normal', 'color': 0xFF10B981},
        'asamUrat': {'value': 6.0, 'status': 'Normal', 'color': 0xFF10B981},
        'detakJantung': {'value': 70, 'status': 'Normal', 'color': 0xFF10B981},
        'saturasi': {'value': 98, 'status': 'Normal', 'color': 0xFF10B981},
        'beratBadan': {'value': 70.5, 'status': 'Normal', 'color': 0xFF10B981},
        'symptoms': [],
        'notes': 'Kontrol gula rutin',
      },
    ];
  }

  static List<Map<String, dynamic>> getRecordsByPatient(String patientId) {
    return _recordsByPatient[patientId] ?? [];
  }

  static Map<String, dynamic>? getLatestRecord(String patientId) {
    final records = getRecordsByPatient(patientId);
    if (records.isEmpty) return null;
    return records.first;
  }

  static List<Map<String, dynamic>> getTrendData(String patientId, String metric, int days) {
    final random = Random(patientId.hashCode + metric.hashCode);
    final List<Map<String, dynamic>> trendData = [];
    final now = DateTime.now();

    double baseValue;
    double variation;
    switch (metric) {
      case 'tensi_systolic':
        baseValue = 130;
        variation = 15;
        break;
      case 'tensi_diastolic':
        baseValue = 85;
        variation = 10;
        break;
      case 'gulaDarah':
        baseValue = 140;
        variation = 30;
        break;
      case 'kolestrol':
        baseValue = 190;
        variation = 25;
        break;
      case 'detakJantung':
        baseValue = 72;
        variation = 10;
        break;
      case 'saturasi':
        baseValue = 97;
        variation = 2;
        break;
      case 'beratBadan':
        baseValue = 65;
        variation = 1;
        break;
      default:
        baseValue = 100;
        variation = 10;
    }

    for (int i = days - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final value = baseValue + (random.nextDouble() - 0.5) * variation * 2;
      trendData.add({
        'date': '${date.month}/${date.day}',
        'value': metric == 'beratBadan' ? double.parse(value.toStringAsFixed(1)) : value.round(),
      });
    }

    return trendData;
  }
}