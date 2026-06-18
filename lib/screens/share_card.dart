import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/credential_model.dart';
import '../providers/user_provider.dart';
import '../providers/credential_provider.dart';
import '../utils/theme.dart';
import '../widgets/app_button.dart';

class ShareCardScreen extends StatelessWidget {
  const ShareCardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final credProvider = Provider.of<CredentialProvider>(context);

    final user = userProvider.user;
    final displayName = user?.name ?? 'Student';
    final userCollege = user?.college ?? 'VIT Vellore';
    final userBranch = user?.branch ?? 'CSE';
    final currentYear = user?.currentYear ?? 3;
    final avatarChar = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'S';

    final portfolioUrl = "verifyu.app/${user?.portfolioHandle ?? 'student'}";
    final totalVerified = credProvider.credentials.where((c) => c.status == VerificationStatus.verified).length;

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 10),
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
                    "share card",
                    style: AppTheme.headingStyle(fontSize: 19, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            // Share Card Outer Frame
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 14),
                  child: Column(
                    children: [
                      // Share Card container matching the HTML layout
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.warmWhite,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.gold, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.ink.withOpacity(0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Corner flag in the top right
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 64,
                                height: 64,
                                decoration: const BoxDecoration(
                                  color: AppColors.rose,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(18),
                                    bottomLeft: Radius.circular(100),
                                  ),
                                ),
                                alignment: const Alignment(0.4, -0.4),
                                child: const Icon(
                                  Icons.shield_outlined,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),

                            // Inside contents
                            Padding(
                              padding: const EdgeInsets.all(26.0),
                              child: Column(
                                children: [
                                  // Wordmark header
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 22,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          color: AppColors.forest,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Icon(
                                          Icons.shield_outlined,
                                          color: AppColors.gold,
                                          size: 13,
                                        ),
                                      ),
                                      const SizedBox(width: 7),
                                      Text(
                                        "VerifyU",
                                        style: AppTheme.headingStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 18),

                                  // Avatar, Name & details
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: const BoxDecoration(
                                      color: AppColors.gold,
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      avatarChar,
                                      style: AppTheme.headingStyle(fontSize: 23, color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    displayName,
                                    style: AppTheme.headingStyle(fontSize: 20, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "$userCollege · Year $currentYear",
                                    style: AppTheme.bodyStyle(fontSize: 12.5, color: AppColors.tan, fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),

                                  // Stats strip
                                  Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: AppColors.ivory,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                totalVerified.toString(),
                                                style: AppTheme.headingStyle(fontSize: 21, color: AppColors.forest, fontWeight: FontWeight.w600),
                                              ),
                                              Text(
                                                "verified",
                                                style: AppTheme.bodyStyle(fontSize: 10.5, color: AppColors.tan, fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(width: 1, height: 24, color: AppColors.sand2),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                "${credProvider.averageTrustScore}",
                                                style: AppTheme.headingStyle(fontSize: 21, color: AppColors.ink, fontWeight: FontWeight.w600),
                                              ),
                                              Text(
                                                "avg trust score",
                                                style: AppTheme.bodyStyle(fontSize: 10.5, color: AppColors.tan, fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 22),

                                  // QR Code Box
                                  Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      color: AppColors.ink,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: QrImageView(
                                      data: "https://verifyu.app/${user?.portfolioHandle ?? 'student'}",
                                      version: QrVersions.auto,
                                      size: 94.0,
                                      eyeStyle: const QrEyeStyle(
                                        eyeShape: QrEyeShape.square,
                                        color: Colors.white,
                                      ),
                                      dataModuleStyle: const QrDataModuleStyle(
                                        dataModuleShape: QrDataModuleShape.square,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 9),
                                  Text(
                                    portfolioUrl,
                                    style: AppTheme.bodyStyle(fontSize: 11, color: AppColors.tan, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Selection style dots mockup
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 20, height: 8, decoration: BoxDecoration(color: AppColors.forest, borderRadius: BorderRadius.circular(4))),
                          const SizedBox(width: 8),
                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.sand2, shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.sand2, shape: BoxShape.circle)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom CTA Buttons
            Container(
              padding: const EdgeInsets.fromLTRB(22, 10, 22, 28),
              child: Column(
                children: [
                  AppButton(
                    text: "Share to recruiter",
                    type: AppButtonType.filledRose,
                    icon: const Icon(Icons.share, color: Colors.white, size: 16),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Sharing trusted card to recruiter apps...")),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    text: "Save image",
                    type: AppButtonType.outlineInk,
                    icon: const Icon(Icons.download, color: AppColors.ink, size: 16),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Saving share card to device storage...")),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
