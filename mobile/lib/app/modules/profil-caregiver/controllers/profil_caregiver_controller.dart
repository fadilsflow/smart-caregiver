import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class ProfilCaregiverController extends GetxController {
  void logout() {
    // In a real app, clear tokens here
    Get.offAllNamed(Routes.LOGIN);
  }

  final count = 0.obs;
  void increment() => count.value++;
}
