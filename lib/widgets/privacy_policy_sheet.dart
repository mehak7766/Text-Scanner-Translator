import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class PrivacyPolicySheet extends StatelessWidget {
  final VoidCallback onAccept;

  const PrivacyPolicySheet({super.key, required this.onAccept});

  static Future<void> show(BuildContext context, {required VoidCallback onAccept}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PrivacyPolicySheet(onAccept: onAccept),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.78,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Drag handle
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 16),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textMedium),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.borderLight),
          // Policy Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Last updated: October 2026',
                    style: TextStyle(fontSize: 13, color: AppColors.textLight),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('1. Camera & Optical Character Recognition (OCR)'),
                  _buildSectionText(
                    'Our Text Scanner app accesses your device camera and selected gallery images solely to extract textual content locally or via secure on-device processing. We do not store, distribute, or view your private camera photos.',
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('2. Translation & Language Services'),
                  _buildSectionText(
                    'When you request translation across languages, extracted text snippets are processed securely to provide instant and accurate multilingual results. No personal identifying information is attached to your translations.',
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('3. Device Storage & Local History'),
                  _buildSectionText(
                    'Scan history, saved translations, and cached vocabulary are kept locally in your device sandbox for your convenience. You have full control to clear history or delete scans at any time.',
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('4. Academic Semester Project Disclaimer'),
                  _buildSectionText(
                    'This application is built with student privacy by design. It does not contain tracking trackers, telemetry profiling, or third-party ad networks.',
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // Accept & Close button
          Padding(
            padding: EdgeInsets.fromLTRB(
              24,
              12,
              24,
              16 + MediaQuery.of(context).padding.bottom,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  onAccept();
                },
                child: const Text(
                  'Accept & Continue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  Widget _buildSectionText(String body) {
    return Text(
      body,
      style: const TextStyle(
        fontSize: 14,
        height: 1.5,
        color: AppColors.textMedium,
      ),
    );
  }
}
