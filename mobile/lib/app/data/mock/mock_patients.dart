class MockPatients {
  static List<Map<String, dynamic>> getPatients() {
    return [
      {
        'id': '1',
        'name': 'Ibu Siti',
        'age': 55,
        'gender': 'Perempuan',
        'photo': 'https://ui-avatars.com/api/?name=Ibu+Siti&background=ec4899&color=fff',
        'status': 'Normal',
        'lastUpdate': 'Hari ini, 08:30',
        'medicalHistory': 'Hipertensi, Diabetes Tipe 2',
        'physicalCondition': 'Mandiri',
        'mobility': 'Bisa Berjalan',
        'interests': 'Memasak, Berkebun',
      },
      {
        'id': '2',
        'name': 'Budi Santoso',
        'age': 72,
        'gender': 'Laki-laki',
        'photo': 'https://ui-avatars.com/api/?name=Budi+Santoso&background=f59e0b&color=fff',
        'status': 'Perlu Perhatian',
        'lastUpdate': 'Kemarin, 18:45',
        'medicalHistory': 'Jantung, Asma',
        'physicalCondition': 'Perlu Bantuan',
        'mobility': 'Perlu Tongkat',
        'interests': 'Memancing, Main Catur',
      },
      {
        'id': '3',
        'name': 'Oma Maria',
        'age': 78,
        'gender': 'Perempuan',
        'photo': 'https://ui-avatars.com/api/?name=Oma+Maria&background=8b5cf6&color=fff',
        'status': 'Normal',
        'lastUpdate': 'Hari ini, 07:15',
        'medicalHistory': 'Arthritis, Osteoporosis',
        'physicalCondition': 'Mandiri',
        'mobility': 'Bisa Berjalan',
        'interests': 'Menjahit, Berkebun',
      },
      {
        'id': '4',
        'name': 'Opa Joko',
        'age': 80,
        'gender': 'Laki-laki',
        'photo': 'https://ui-avatars.com/api/?name=Opa+Joko&background=10b981&color=fff',
        'status': 'Normal',
        'lastUpdate': 'Hari ini, 09:00',
        'medicalHistory': 'Diabetes Tipe 2, Kolesterol Tinggi',
        'physicalCondition': 'Mandiri',
        'mobility': 'Bisa Berjalan',
        'interests': 'Berkebun, Membaca',
      },
    ];
  }

  static Map<String, dynamic>? getPatientById(String id) {
    final patients = getPatients();
    try {
      return patients.firstWhere((p) => p['id'] == id);
    } catch (e) {
      return null;
    }
  }
}