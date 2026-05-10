import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final name = ''.obs;
  final email = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;

  void togglePasswordVisibility() =>
      obscurePassword.value = !obscurePassword.value;
  void toggleConfirmPasswordVisibility() =>
      obscureConfirmPassword.value = !obscureConfirmPassword.value;

  void register() {
    if (name.value.isEmpty || email.value.isEmpty || password.value.isEmpty) {
      Get.snackbar('Error', 'Semua field harus diisi');
      return;
    }
    if (password.value != confirmPassword.value) {
      Get.snackbar('Error', 'Password tidak cocok');
      return;
    }

    // Simulate successful registration
    Get.snackbar('Success', 'Registrasi berhasil! Silakan masuk.');
    Get.offAllNamed(Routes.LOGIN);
  }
}
