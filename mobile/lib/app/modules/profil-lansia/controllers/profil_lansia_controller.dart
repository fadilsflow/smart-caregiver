import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class ProfilLansiaController extends GetxController {
  //TODO: Implement ProfilLansiaController

  final currentIndex = 3.obs;

  final TextEditingController namaController = TextEditingController(text: 'Ibu Siti');
  final TextEditingController umurController = TextEditingController(text: '55');
  final TextEditingController jenisKelaminController = TextEditingController(text: 'Perempuan');
  final TextEditingController riwayatMedisController = TextEditingController(text: 'Hipertensi ringan');
  final TextEditingController minatHobiController = TextEditingController(text: 'Berkebun dan Membaca');

  void changePage(int index) {
    if (currentIndex.value == index) return;
    
    int previousIndex = currentIndex.value;
    currentIndex.value = index;
    
    if (index == 0) {
      Get.offNamed(Routes.DASHBOARD, arguments: {'from': previousIndex});
    } else if (index == 1) {
      Get.offNamed(Routes.CALENDAR, arguments: {'from': previousIndex});
    } else if (index == 2) {
      Get.offNamed(Routes.PATIENT_DETAIL, arguments: {'from': previousIndex});
    } else if (index == 3) {
      Get.offNamed(Routes.PROFIL_LANSIA, arguments: {'from': previousIndex});
    }
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is Map && Get.arguments['from'] != null) {
      currentIndex.value = Get.arguments['from'];
    }
  }

  void saveChanges() {
    Get.snackbar(
      'Berhasil',
      'Data profil berhasil diperbarui',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFFBBF246),
      colorText: const Color(0xFF192126),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(Icons.check_circle, color: Color(0xFF192126)),
    );
  }

  @override
  void onReady() {
    super.onReady();
    if (currentIndex.value != 3) {
      Future.delayed(const Duration(milliseconds: 10), () {
        currentIndex.value = 3;
      });
    }
  }

  @override
  void onClose() {
    namaController.dispose();
    umurController.dispose();
    jenisKelaminController.dispose();
    riwayatMedisController.dispose();
    minatHobiController.dispose();
    super.onClose();
  }

  void increment() => count.value++;
}
