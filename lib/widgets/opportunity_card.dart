import 'package:flutter/material.dart';
import '../models/opportunity_model.dart';
import '../utils/theme.dart';
import 'app_button.dart';

class OpportunityCard extends StatelessWidget {
  final OpportunityModel opportunity;
  final VoidCallback? onApply;

  const OpportunityCard({
    Key? key,
    required this.opportunity,
    this.onApply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color matchColor;
    if (opportunity.matchPercentage >= 90) {
      matchColor = AppColors.forest;
    } else if (opportunity.matchPercentage >= 75) {
      matchColor = AppColors.gold;
    } else {
      matchColor = AppColors.clay;
    }

    return Card(
      elevation: 0,
      color: AppColors.warmWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.sand, width: 1),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.sand,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          opportunity.category.toUpperCase(),
                          style: AppTheme.bodyStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.tan,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        opportunity.title,
                        style: AppTheme.bodyStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                        ),
                      ),
                      Text(
                        "${opportunity.organization} · ${opportunity.location}",
                        style: AppTheme.bodyStyle(
                          fontSize: 12,
                          color: AppColors.tan,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Match percentage badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: matchColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${opportunity.matchPercentage}% Match",
                    style: AppTheme.bodyStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: matchColor,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(color: AppColors.sand, height: 24),
            Text(
              "Navigator Matching Analysis:",
              style: AppTheme.bodyStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: AppColors.tan,
              ),
            ),
            const SizedBox(height: 6),
            Column(
              children: opportunity.matchReasons.map((reason) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        reason.startsWith('✓') ? Icons.check : Icons.star_border,
                        size: 14,
                        color: AppColors.forest,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          reason.startsWith('✓') ? reason.substring(2) : reason,
                          style: AppTheme.bodyStyle(
                            fontSize: 12.5,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            AppButton(
              text: "Apply Now",
              type: AppButtonType.filledForest,
              onPressed: onApply ?? () {},
            ),
          ],
        ),
      ),
    );
  }
}
