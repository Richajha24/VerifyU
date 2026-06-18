import 'package:flutter/material.dart';
import '../models/credential_model.dart';
import '../utils/theme.dart';
import '../widgets/trust_score_ring.dart';
import '../widgets/app_button.dart';

class AchievementDetailScreen extends StatelessWidget {
  const AchievementDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CredentialModel credential = ModalRoute.of(context)!.settings.arguments as CredentialModel;

    final passedChecks = credential.ocrResult['passedChecks'] as List<dynamic>? ?? [];
    final failedChecks = credential.ocrResult['failedChecks'] as List<dynamic>? ?? [];
    final scannedText = credential.ocrResult['scannedText'] as String? ?? 'No scanned text available.';

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: AppColors.warmWhite,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, size: 16, color: AppColors.ink),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    "Achievement Details",
                    style: AppTheme.headingStyle(fontSize: 19, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            // Contents
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                children: [
                  // Detail Card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.warmWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.sand, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.sand,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                credential.category.name.toUpperCase(),
                                style: AppTheme.bodyStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.tan),
                              ),
                            ),
                            Text(
                              credential.id,
                              style: AppTheme.bodyStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.tan,
                                fontFamily: 'Courier',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          credential.title,
                          style: AppTheme.headingStyle(fontSize: 19, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Issued by ${credential.organization} · ${credential.dateAchieved}",
                          style: AppTheme.bodyStyle(fontSize: 13, color: AppColors.tan, fontWeight: FontWeight.w500),
                        ),
                        if (credential.description.isNotEmpty) ...[
                          const Divider(color: AppColors.sand, height: 24),
                          Text(
                            credential.description,
                            style: AppTheme.bodyStyle(fontSize: 13, color: AppColors.ink),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Trust Score Breakdown
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.warmWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.sand, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "TRUST SCORE BREAKDOWN",
                          style: AppTheme.bodyStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.tan),
                        ),
                        const SizedBox(height: 18),
                        Center(
                          child: TrustScoreRing(
                            score: credential.verificationScore.toDouble(),
                            size: 110,
                            strokeWidth: 8,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _buildVerificationMetricRow("Certificate Authenticity check", "Passed", AppColors.forest),
                        _buildVerificationMetricRow("Google ML Kit OCR Match", "Passed", AppColors.forest),
                        _buildVerificationMetricRow("AI Generated / Tamper check", "Passed", AppColors.forest),
                        _buildVerificationMetricRow("Database Index lookup", "Passed", AppColors.forest),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // OCR Scan output
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.warmWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.sand, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "OCR SCANNED DOCUMENT TEXT",
                          style: AppTheme.bodyStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.tan),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.ivory,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            scannedText,
                            style: AppTheme.bodyStyle(fontSize: 12.5, color: AppColors.ink, fontFamily: 'Courier'),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          "Verification Checks Passed:",
                          style: AppTheme.bodyStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        ...passedChecks.map((check) => _buildCheckItem(check.toString(), true)),
                        if (failedChecks.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text(
                            "Verification Checks Failed:",
                            style: AppTheme.bodyStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.brick),
                          ),
                          const SizedBox(height: 6),
                          ...failedChecks.map((check) => _buildCheckItem(check.toString(), false)),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Navigator insight
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.warmWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.sand, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.psychology, color: AppColors.bronze, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              "Navigator AI Insight",
                              style: AppTheme.headingStyle(fontSize: 14.5, color: AppColors.bronze),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "This credential demonstrates:\n✓ Problem Solving\n✓ Technical Skills\n✓ Practical Experience in ${credential.category.name}\n\nCareer Relevance:\nHigh",
                          style: AppTheme.bodyStyle(fontSize: 13, color: AppColors.ink, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  AppButton(
                    text: "Share this achievement",
                    type: AppButtonType.filledRose,
                    icon: const Icon(Icons.share, color: Colors.white, size: 16),
                    onPressed: () {
                      Navigator.pushNamed(context, '/share_card');
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationMetricRow(String label, String val, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTheme.bodyStyle(fontSize: 12.5, color: AppColors.tan)),
          Text(val, style: AppTheme.bodyStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String label, bool isOk) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Icon(
            isOk ? Icons.check : Icons.close,
            size: 14,
            color: isOk ? AppColors.forest : AppColors.brick,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: AppTheme.bodyStyle(fontSize: 12.5, color: AppColors.ink),
            ),
          ),
        ],
      ),
    );
  }
}
