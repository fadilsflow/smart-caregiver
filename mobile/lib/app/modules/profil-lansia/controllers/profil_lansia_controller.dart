import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class ProfilLansiaController extends GetxController {
  //TODO: Implement ProfilLansiaController

  final currentIndex = 3.obs;

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
    super.onClose();
  }

  void increment() => count.value++;
}
