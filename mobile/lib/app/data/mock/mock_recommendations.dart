class MockRecommendations {
  static final List<Map<String, dynamic>> _recommendations = [
    {
      'id': '1',
      'patientId': '1',
      'title': 'Senam Kursi',
      'description': 'Latihan fisik ringan khusus untuk lansia yang dilakukan sambil duduk',
      'duration': 20,
      'durationLabel': '20 menit',
      'category': 'Kebugaran',
      'icon': 'accessibility_new',
      'reason': 'Membantu menjaga fleksibilitas dan kekuatan otot tanpa risiko jatuh',
      'instructions': [
        'Duduk tegak di kursi dengan kaki rata di lantai',
        'Angkat tangan ke atas, rentangkan sepenuhnya',
        'Putar tubuh ke kiri dan kanan secara perlahan',
        'Angkat kaki secara bergantian',
        'Lakukan gerakan selama 20 menit dengan istirahat di antaranya',
      ],
      'scheduledAt': null,
      'isApproved': false,
    },
    {
      'id': '2',
      'patientId': '1',
      'title': 'Terapi Musik',
      'description': 'Mendengarkan musik klasik atau tradisional untuk relaksasi',
      'duration': 30,
      'durationLabel': '30 menit',
      'category': 'Kesejahteraan',
      'icon': 'music_note',
      'reason': 'Musik dapat mengurangi stres, meningkatkan mood, dan membantu relaksasi',
      'instructions': [
        'Pilih ruangan yang tenang dan nyaman',
        'Mainkan musik klasik atau tradisional yang tenang',
        'Tutup mata dan nikamati alunan musik',
        'Tarik napas dalam-dalam secara perlahan',
        'Biarkan tubuh relax sepenuhnya',
      ],
      'scheduledAt': null,
      'isApproved': false,
    },
    {
      'id': '3',
      'patientId': '1',
      'title': 'Berkebun',
      'description': 'Aktivitas berkebun ringan di halaman atau taman',
      'duration': 45,
      'durationLabel': '45 menit',
      'category': 'Aktivitas Luar',
      'icon': 'yard',
      'reason': 'Berkebun memberikan aktivitas fisik ringan dan paparan sinar matahari untuk vitamin D',
      'instructions': [
        'Pilih tanaman yang mudah perawatan',
        'Gunakan alat berkebun yang ergonomis',
        'Jangan terlalu lelah, istirahat secara berkala',
        'Minum air putih yang cukup',
        'Lakukan pada pagi hari sebelum matahari terlalu terik',
      ],
      'scheduledAt': null,
      'isApproved': false,
    },
    {
      'id': '4',
      'patientId': '1',
      'title': 'Membaca',
      'description': 'Membaca buku, majalah, atau koran',
      'duration': 30,
      'durationLabel': '30 menit',
      'category': 'Kognitif',
      'icon': 'menu_book',
      'reason': 'Membaca menjaga kesehatan otak dan mencegah penurunan kognitif',
      'instructions': [
        'Pilih ruangan dengan pencahayaan yang baik',
        'Gunakan kacamata baca jika diperlukan',
        'Baca dengan posisi yang nyaman',
        'Istirahat sebentar setiap 15 menit',
        'Diskusikan apa yang dibaca dengan anggota keluarga',
      ],
      'scheduledAt': null,
      'isApproved': false,
    },
    {
      'id': '5',
      'patientId': '2',
      'title': 'Latihan Pernapasan',
      'description': 'Teknik pernapasan dalam untuk meningkatkan kapasitas paru',
      'duration': 15,
      'durationLabel': '15 menit',
      'category': 'Kebugaran',
      'icon': 'air',
      'reason': 'Membantu memperluas kapasitas paru dan mengurangi sesak napas',
      'instructions': [
        'Duduk atau berbaring dalam posisi nyaman',
        'Tarik napas perlahan melalui hidung selama 4 detik',
        'Tahan napas selama 4 detik',
        'Hembuskan perlahan melalui mulut selama 6 detik',
        'Ulangi 5-10 kali',
      ],
      'scheduledAt': null,
      'isApproved': false,
    },
    {
      'id': '6',
      'patientId': '3',
      'title': 'Pijat Ringan',
      'description': 'Pijat lembut untuk mengatasi stiffness pada sendi',
      'duration': 20,
      'durationLabel': '20 menit',
      'category': 'Kesejahteraan',
      'icon': 'spa',
      'reason': 'Membantu melancarkan sirkulasi dan mengurangi kekakuan sendi',
      'instructions': [
        'Gunakan minyak pijat atau lotion',
        'Pijat lembut area yang kaku dengan gerakan melingkar',
        'Fokus pada tangan, kaki, dan sendi',
        'Hindari tekanan terlalu keras',
        'Lakukan di ruangan yang hangat',
      ],
      'scheduledAt': null,
      'isApproved': false,
    },
  ];

  static List<Map<String, dynamic>> getRecommendationsByPatient(String patientId) {
    return _recommendations.where((r) => r['patientId'] == patientId).toList();
  }

  static Map<String, dynamic>? getRecommendationById(String id) {
    try {
      return _recommendations.firstWhere((r) => r['id'] == id);
    } catch (e) {
      return null;
    }
  }

  static Map<String, dynamic> approveRecommendation(String id, String scheduledTime) {
    final index = _recommendations.indexWhere((r) => r['id'] == id);
    if (index != -1) {
      _recommendations[index]['isApproved'] = true;
      _recommendations[index]['scheduledAt'] = scheduledTime;
      return _recommendations[index];
    }
    throw Exception('Recommendation not found');
  }

  static Map<String, dynamic> rejectRecommendation(String id) {
    _recommendations.removeWhere((r) => r['id'] == id);
    return {'success': true};
  }
}