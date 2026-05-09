class MockSchedules {
  static final List<Map<String, dynamic>> _schedules = [
    {
      'id': '1',
      'patientId': '1',
      'title': 'Minum Obat Hipertensi',
      'type': 'Medis',
      'icon': 'medication',
      'description': 'Minum obat pengontrol tekanan darah',
      'time': '08:00',
      'frequency': 'Setiap Hari',
      'reminder': 15,
      'isCompleted': false,
    },
    {
      'id': '2',
      'patientId': '1',
      'title': 'Pemeriksaan Gula Darah',
      'type': 'Pemeriksaan',
      'icon': 'bloodtype',
      'description': 'Ukur kadar gula darah secara berkala',
      'time': '09:30',
      'frequency': 'Setiap Hari',
      'reminder': 10,
      'isCompleted': true,
    },
    {
      'id': '3',
      'patientId': '1',
      'title': 'Senam Pagi',
      'type': 'Aktivitas',
      'icon': 'fitness_center',
      'description': 'Senam ringan selama 30 menit',
      'time': '10:00',
      'frequency': 'Setiap Hari',
      'reminder': 15,
      'isCompleted': true,
    },
    {
      'id': '4',
      'patientId': '1',
      'title': 'Kontrol Dokter',
      'type': 'Pemeriksaan',
      'icon': 'local_hospital',
      'description': 'Kontrol rutin ke dr. Ahmad',
      'time': '14:00',
      'frequency': 'Mingguan',
      'reminder': 60,
      'isCompleted': false,
    },
    {
      'id': '5',
      'patientId': '1',
      'title': 'Terapi Diabetes',
      'type': 'Medis',
      'icon': 'medication',
      'description': 'Minum obat diabetes setelah makan siang',
      'time': '13:00',
      'frequency': 'Setiap Hari',
      'reminder': 15,
      'isCompleted': false,
    },
    {
      'id': '6',
      'patientId': '1',
      'title': 'Berkebun',
      'type': 'Aktivitas',
      'icon': 'yard',
      'description': 'Merawat tanaman di halaman',
      'time': '16:00',
      'frequency': 'Setiap Hari',
      'reminder': 30,
      'isCompleted': false,
    },
    {
      'id': '7',
      'patientId': '1',
      'title': 'Minum Obat Malam',
      'type': 'Medis',
      'icon': 'medication',
      'description': 'Minum obat untuk tidur',
      'time': '21:00',
      'frequency': 'Setiap Hari',
      'reminder': 15,
      'isCompleted': false,
    },
    {
      'id': '8',
      'patientId': '2',
      'title': 'Inhaler Asma',
      'type': 'Medis',
      'icon': 'air',
      'description': 'Gunakan inhaler sesuai anjuran',
      'time': '07:00',
      'frequency': 'Setiap Hari',
      'reminder': 10,
      'isCompleted': true,
    },
    {
      'id': '9',
      'patientId': '2',
      'title': 'Pemeriksaan Jantung',
      'type': 'Pemeriksaan',
      'icon': 'favorite',
      'description': 'Cek detak jantung dan tekanan darah',
      'time': '11:00',
      'frequency': 'Setiap Hari',
      'reminder': 15,
      'isCompleted': false,
    },
    {
      'id': '10',
      'patientId': '2',
      'title': 'Fisioterapi',
      'type': 'Aktivitas',
      'icon': 'accessibility_new',
      'description': 'Latihan mobilitas dengan terapis',
      'time': '15:00',
      'frequency': 'Mingguan',
      'reminder': 30,
      'isCompleted': false,
    },
  ];

  static List<Map<String, dynamic>> getSchedulesByPatient(String patientId) {
    return _schedules.where((s) => s['patientId'] == patientId).toList();
  }

  static List<Map<String, dynamic>> getSchedulesForToday(String patientId) {
    return getSchedulesByPatient(patientId);
  }

  static Map<String, List<Map<String, dynamic>>> getCalendarSchedules(String patientId) {
    final schedules = getSchedulesByPatient(patientId);
    final Map<String, List<Map<String, dynamic>>> grouped = {
      'Morning': [],
      'Afternoon': [],
      'Evening': [],
    };

    for (final schedule in schedules) {
      final time = schedule['time'] as String;
      final hour = int.parse(time.split(':')[0]);

      if (hour >= 5 && hour < 12) {
        grouped['Morning']!.add(schedule);
      } else if (hour >= 12 && hour < 18) {
        grouped['Afternoon']!.add(schedule);
      } else {
        grouped['Evening']!.add(schedule);
      }
    }

    for (var key in grouped.keys) {
      grouped[key]!.sort((a, b) => a['time'].compareTo(b['time']));
    }

    return grouped;
  }

  static Map<String, dynamic>? getScheduleById(String id) {
    try {
      return _schedules.firstWhere((s) => s['id'] == id);
    } catch (e) {
      return null;
    }
  }
}