import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/user_provider.dart';
import '../providers/credential_provider.dart';
import '../utils/theme.dart';
import '../widgets/trust_score_ring.dart';
import '../widgets/credential_card.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final credProvider = Provider.of<CredentialProvider>(context);

    final user = userProvider.user;
    final displayName = user?.name ?? 'Student';
    final userCollege = user?.college ?? 'VIT Vellore';
    final userBranch = user?.branch ?? 'CSE';
    final year = user?.currentYear ?? 3;
    final avatarChar = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'S';

    final portfolioUrl = "verifyu.app/${user?.portfolioHandle ?? 'student'}";

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: SafeArea(
        child: Column(
          children: [
            // Header Card matching theme
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.forest,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 26),
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
                  Text(
                    "$userCollege · Year $year · $userBranch",
                    style: AppTheme.bodyStyle(fontSize: 12.5, color: const Color(0xFFCFE0D2)),
                  ),
                  const SizedBox(height: 16),
                  // Share Card CTA
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/share_card');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.share, color: Colors.white, size: 13),
                          const SizedBox(width: 6),
                          Text(
                            "My share card",
                            style: AppTheme.bodyStyle(fontSize: 12.5, color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Portfolio lists
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
                children: [
                  // Trust Score Breakdown
                  _buildTrustScoreSection(credProvider.averageTrustScore, credProvider.credentials.length),
                  const SizedBox(height: 22),

                  // Skills
                  Text(
                    "SKILLS",
                    style: AppTheme.bodyStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.tan),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (user?.careerInterests ?? ['App Development', 'Problem Solving']).map((interest) {
                      return Chip(
                        label: Text(interest),
                        backgroundColor: AppColors.warmWhite,
                        labelStyle: AppTheme.bodyStyle(fontSize: 12.5, color: AppColors.ink, fontWeight: FontWeight.w600),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: const BorderSide(color: AppColors.sand, width: 1),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 22),

                  // Career Snapshot (Generated by Navigator)
                  _buildCareerSnapshotSection(userBranch),
                  const SizedBox(height: 22),

                  // Verified Achievements List
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "VERIFIED CREDENTIALS",
                        style: AppTheme.bodyStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.tan),
                      ),
                      const Icon(Icons.lock_outline, size: 14, color: AppColors.tan),
                    ],
                  ),
                  const SizedBox(height: 10),
                  credProvider.credentials.isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.warmWhite,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.sand, width: 1),
                          ),
                          child: const Center(child: Text("No credentials added yet.")),
                        )
                      : Column(
                          children: credProvider.credentials.map((cred) {
                            return CredentialCard(
                              credential: cred,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/credential_detail',
                                  arguments: cred,
                                );
                              },
                            );
                          }).toList(),
                        ),
                  const SizedBox(height: 22),

                  // Share/Public link
                  Text(
                    "PUBLIC PORTFOLIO LINK",
                    style: AppTheme.bodyStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.tan),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.warmWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.sand, width: 1),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.link, color: AppColors.forest),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            portfolioUrl,
                            style: AppTheme.bodyStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, color: AppColors.tan, size: 18),
                          onPressed: () {
                            Share.share("Checkout my trusted verified career portfolio at $portfolioUrl");
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Portfolio link copied!")),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustScoreSection(int avgScore, int totalCount) {
    return Card(
      elevation: 0,
      color: AppColors.warmWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.sand, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: [
            TrustScoreRing(score: avgScore.toDouble(), size: 100, strokeWidth: 8),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Verification Standing",
                    style: AppTheme.headingStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Your average trust score is verified across $totalCount achievements. Recruiters see this score as a measure of document authenticity.",
                    style: AppTheme.bodyStyle(fontSize: 12.5, color: AppColors.tan),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCareerSnapshotSection(String branch) {
    return Card(
      elevation: 0,
      color: AppColors.warmWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.sand, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.psychology, color: AppColors.bronze, size: 20),
                const SizedBox(width: 8),
                Text(
                  "AI Career Snapshot",
                  style: AppTheme.headingStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.bronze),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "Strong Areas:",
              style: AppTheme.bodyStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink),
            ),
            const SizedBox(height: 4),
            Text(
              "• Flutter App Architecture\n• Basic Firebase integration\n• Rapid UI Mockups\n• Hackathon teamwork & presentation",
              style: AppTheme.bodyStyle(fontSize: 12.5, color: AppColors.ink),
            ),
            const SizedBox(height: 12),
            Text(
              "Recommended Next Steps:",
              style: AppTheme.bodyStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink),
            ),
            const SizedBox(height: 4),
            Text(
              "• Learn Flutter State Management (Provider)\n• Upload a production app link to Firestore\n• Join a regional developer hackathon",
              style: AppTheme.bodyStyle(fontSize: 12.5, color: AppColors.ink),
            ),
          ],
        ),
      ),
    );
  }
}
