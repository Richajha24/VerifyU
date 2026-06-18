import 'package:flutter/material.dart';
import '../models/credential_model.dart';
import '../utils/theme.dart';

class CredentialCard extends StatelessWidget {
  final CredentialModel credential;
  final VoidCallback? onTap;

  const CredentialCard({
    Key? key,
    required this.credential,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color progressColor;
    Color statusBgColor;
    Color statusTextColor;
    String statusLabel;
    IconData statusIcon;

    // Determine colors/badges based on status & score
    if (credential.status == VerificationStatus.verified) {
      statusLabel = "cross-verified";
      statusBgColor = AppColors.tierCrossVerifiedBg;
      statusTextColor = AppColors.forest;
      statusIcon = Icons.check_circle_outline;
      progressColor = AppColors.forest;
    } else if (credential.status == VerificationStatus.flagged) {
      statusLabel = "flagged";
      statusBgColor = AppColors.tierFlaggedBg;
      statusTextColor = AppColors.brick;
      statusIcon = Icons.error_outline;
      progressColor = AppColors.brick;
    } else {
      // Review Needed / Consistent / Needs Proof
      if (credential.verificationScore >= 70) {
        statusLabel = "consistent";
        statusBgColor = AppColors.tierDocumentConsistentBg;
        statusTextColor = AppColors.gold;
        statusIcon = Icons.star_border;
        progressColor = AppColors.gold;
      } else if (credential.verificationScore >= 50) {
        statusLabel = "in review";
        statusBgColor = AppColors.tierPartialMatchBg;
        statusTextColor = AppColors.clay;
        statusIcon = Icons.hourglass_empty;
        progressColor = AppColors.clay;
      } else {
        statusLabel = "needs proof";
        statusBgColor = AppColors.tierNeedsProofBg;
        statusTextColor = AppColors.rose;
        statusIcon = Icons.warning_amber_outlined;
        progressColor = AppColors.rose;
      }
    }

    return Card(
      elevation: 0,
      color: AppColors.warmWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: credential.status == VerificationStatus.flagged
              ? AppColors.brick.withOpacity(0.5)
              : credential.verificationScore < 50
                  ? AppColors.rose.withOpacity(0.5)
                  : Colors.transparent,
          width: 1.5,
        ),
      ),
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          credential.title,
                          style: AppTheme.bodyStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          "${credential.organization} · ${credential.dateAchieved}",
                          style: AppTheme.bodyStyle(
                            fontSize: 12,
                            color: AppColors.tan,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          statusIcon,
                          size: 12,
                          color: statusTextColor,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          statusLabel,
                          style: AppTheme.bodyStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: statusTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              Row(
                children: [
                  SizedBox(
                    width: 32,
                    child: Text(
                      credential.verificationScore.toString(),
                      style: AppTheme.headingStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: progressColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: credential.verificationScore / 100,
                        minHeight: 7,
                        backgroundColor: AppColors.sand,
                        valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
