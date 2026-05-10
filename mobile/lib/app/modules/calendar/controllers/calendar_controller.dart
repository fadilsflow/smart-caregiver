import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class CalendarController extends GetxController {
  final currentIndex = 1.obs;

  // Patient Data
  final patientName = 'Ibu Siti'.obs;
  final patientAge = '55 Tahun'.obs;
  final patientImage = 'assets/images/patient_ibu_siti.png'.obs;
  final patientGender = 'Perempuan'.obs;

  // Mock schedule data representing ScheduleResponse
  final mockSchedules = <Map<String, dynamic>>[
    {
      "id": "1",
      "title": "Minum Obat Aspirin",
      "schedule_type": "medication",
      "scheduled_at": DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        8,
        0,
      ),
      "duration_minutes": 15,
      "is_completed": false,
    },
    {
      "id": "2",
      "title": "Pemeriksaan Tekanan Darah",
      "schedule_type": "routine_checkup",
      "scheduled_at": DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        10,
        0,
      ),
      "duration_minutes": 30,
      "is_completed": false,
    },
    {
      "id": "3",
      "title": "Jalan Pagi",
      "schedule_type": "daily_activity",
      "scheduled_at": DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        16,
        0,
      ),
      "duration_minutes": 45,
      "is_completed": true,
    },
  ].obs;

  void toggleScheduleCompletion(String id) {
    final index = mockSchedules.indexWhere((s) => s["id"] == id);
    if (index != -1) {
      final schedule = Map<String, dynamic>.from(mockSchedules[index]);
      schedule["is_completed"] = !(schedule["is_completed"] as bool);
      mockSchedules[index] = schedule;
    }
  }

  void addSchedule(Map<String, dynamic> scheduleData) {
    scheduleData["id"] = DateTime.now().millisecondsSinceEpoch.toString();
    scheduleData["is_completed"] = false;
    mockSchedules.add(scheduleData);

    mockSchedules.sort(
      (a, b) => (a["scheduled_at"] as DateTime).compareTo(
        b["scheduled_at"] as DateTime,
      ),
    );
  }

  void changePage(int index) {
    if (currentIndex.value == index) return;

    int previousIndex = currentIndex.value;
    currentIndex.value = index;

    final args = {
      'from': previousIndex,
      'name': patientName.value,
      'age': patientAge.value,
      'image': patientImage.value,
      'gender': patientGender.value,
    };

    if (index == 0) {
      Get.offNamed(Routes.DASHBOARD, arguments: args);
    } else if (index == 1) {
      Get.offNamed(Routes.CALENDAR, arguments: args);
    } else if (index == 2) {
      Get.offNamed(Routes.PATIENT_DETAIL, arguments: args);
    } else if (index == 3) {
      Get.offNamed(Routes.PROFIL_LANSIA, arguments: args);
    }
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      if (Get.arguments['from'] != null) {
        currentIndex.value = Get.arguments['from'];
      }
      if (Get.arguments['name'] != null) {
        patientName.value = Get.arguments['name'];
      }
      if (Get.arguments['age'] != null) {
        patientAge.value = Get.arguments['age'];
      }
      if (Get.arguments['image'] != null) {
        patientImage.value = Get.arguments['image'];
      }
      if (Get.arguments['gender'] != null) {
        patientGender.value = Get.arguments['gender'];
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    if (currentIndex.value != 1) {
      Future.delayed(const Duration(milliseconds: 10), () {
        currentIndex.value = 1;
      });
    }
  }

  void increment() => count.value++;
}
