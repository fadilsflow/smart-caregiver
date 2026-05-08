import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notifikasi_controller.dart';

class NotifikasiView extends GetView<NotifikasiController> {
  const NotifikasiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => Get.back(),
                      borderRadius: BorderRadius.circular(9999),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color: Color(0xFF18181B),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Notifikasi',
                      style: TextStyle(
                        color: Color(0xFF18181B),
                        fontSize: 20,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w600,
                        height: 1.60,
                        letterSpacing: -0.60,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Notification Cards
                _buildNotificationCard(
                  name: 'Semua Lansia',
                  time: '08.30',
                  description: 'Terapi Fisik: Peregangan ringan',
                  hasDot: true,
                ),
                const SizedBox(height: 16),
                _buildNotificationCard(
                  name: 'Ibu Siti',
                  time: '07.00',
                  description:
                      'Obat pagi: Aspirin & Vitamin, diminum sesudah makan.',
                  hasDot: true,
                ),
                const SizedBox(height: 16),
                _buildNotificationCard(
                  name: 'Opa Joko',
                  time: '07.00',
                  description:
                      'Obat pagi: Aspirin & Vitamin, diminum sesudah makan.',
                  hasDot: true,
                ),
                const SizedBox(height: 16),
                _buildNotificationCard(
                  name: 'Oma Maria',
                  time: 'Kemarin',
                  description:
                      'Obat pagi: Aspirin & Vitamin, diminum sesudah makan.',
                  hasDot: false,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required String name,
    required String time,
    required String description,
    required bool hasDot,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF384046),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w500,
                  height: 1.38,
                ),
              ),
              Row(
                children: [
                  Text(
                    time,
                    style: const TextStyle(
                      color: Color(0xFF737373),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (hasDot) ...[
                    const SizedBox(width: 8),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFFBBF246),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.50),
              fontSize: 13,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
