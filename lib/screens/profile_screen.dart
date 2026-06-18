import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/credential_model.dart';
import '../providers/user_provider.dart';
import '../providers/credential_provider.dart';
import '../utils/theme.dart';
import '../widgets/app_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

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

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Avatar and edit button
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.forest,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 30),
              child: Column(
                children: [
                  Container(
                    width: 74,
                    height: 74,
                    decoration: const BoxDecoration(
                      color: AppColors.gold,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      avatarChar,
                      style: AppTheme.headingStyle(fontSize: 28, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    displayName,
                    style: AppTheme.headingStyle(fontSize: 21, color: Colors.white),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "$userCollege · Year $currentYear · $userBranch",
                    style: AppTheme.bodyStyle(fontSize: 12.5, color: const Color(0xFFCFE0D2)),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.16),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.edit, color: Colors.white, size: 12),
                        const SizedBox(width: 6),
                        Text(
                          "Edit profile",
                          style: AppTheme.bodyStyle(fontSize: 12.5, color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Profile statistics strip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              child: Row(
                children: [
                  _buildStatColumn(
                    credProvider.credentials.where((c) => c.status == VerificationStatus.verified).length.toString(),
                    "verified",
                    AppColors.forest,
                  ),
                  _buildDivider(),
                  _buildStatColumn(
                    credProvider.credentials.length.toString(),
                    "total",
                    AppColors.ink,
                  ),
                  _buildDivider(),
                  _buildStatColumn(
                    "${credProvider.averageTrustScore}",
                    "avg score",
                    AppColors.gold,
                  ),
                ],
              ),
            ),

            // Settings lists
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
                children: [
                  Text(
                    "PORTFOLIO",
                    style: AppTheme.bodyStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.tan),
                  ),
                  const SizedBox(height: 10),
                  _buildMenuRow(
                    context,
                    Icons.share_outlined,
                    AppColors.forest,
                    "My share card",
                    () => Navigator.pushNamed(context, '/share_card'),
                  ),
                  _buildMenuRow(
                    context,
                    Icons.link,
                    AppColors.gold,
                    "Public portfolio link",
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Copied link: $portfolioUrl")),
                      );
                    },
                  ),
                  const SizedBox(height: 22),

                  Text(
                    "ACCOUNT",
                    style: AppTheme.bodyStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.tan),
                  ),
                  const SizedBox(height: 10),
                  _buildMenuRow(
                    context,
                    Icons.settings_outlined,
                    AppColors.ink,
                    "Settings",
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Settings menu details... (API Keys / Auth)")),
                      );
                    },
                  ),
                  _buildMenuRow(
                    context,
                    Icons.logout,
                    AppColors.rose,
                    "Log out",
                    () async {
                      await userProvider.signOut();
                      Navigator.pushReplacementNamed(context, '/login');
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

  Widget _buildStatColumn(String count, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            count,
            style: AppTheme.headingStyle(fontSize: 23, fontWeight: FontWeight.w600, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTheme.bodyStyle(fontSize: 11, color: AppColors.tan, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 28,
      color: AppColors.sand,
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  Widget _buildMenuRow(
    BuildContext context,
    IconData icon,
    Color iconColor,
    String label,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 0,
      color: AppColors.warmWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.ivory,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Text(
                  label,
                  style: AppTheme.bodyStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.ink),
                ),
              ),
              const Icon(Icons.chevron_right, size: 16, color: AppColors.tan),
            ],
          ),
        ),
      ),
    );
  }
}
