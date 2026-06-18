import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/credential_provider.dart';
import '../providers/opportunity_provider.dart';
import '../utils/theme.dart';
import '../widgets/credential_card.dart';
import '../widgets/opportunity_card.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({Key? key}) : super(key: key);

  String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final credProvider = Provider.of<CredentialProvider>(context);
    final oppProvider = Provider.of<OpportunityProvider>(context);

    final user = userProvider.user;

    // Default values if user state isn't initialized yet
    final displayName = user?.name ?? 'Student';
    final userCollege = user?.college ?? 'VIT Vellore';
    final userBranch = user?.branch ?? 'CSE';
    final avatarChar = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'S';

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            if (user != null) {
              await credProvider.fetchCredentials(user.id);
              await oppProvider.fetchOpportunities(user, credProvider.credentials);
            }
          },
          color: AppColors.forest,
          child: Column(
            children: [
              // 1. Greeting & Profile Header Area
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.forest,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(22, 14, 22, 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(Icons.shield_outlined, color: AppColors.gold, size: 16),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "VerifyU",
                              style: AppTheme.headingStyle(fontSize: 19, color: Colors.white),
                            ),
                          ],
                        ),
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.16),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.notifications_none, color: Colors.white, size: 20),
                            ),
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(top: 2, right: 2),
                              decoration: const BoxDecoration(
                                color: AppColors.rose,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: const BoxDecoration(
                            color: AppColors.gold,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            avatarChar,
                            style: AppTheme.headingStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 13),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${_getTimeBasedGreeting()}, $displayName",
                              style: AppTheme.headingStyle(fontSize: 18, color: Colors.white),
                            ),
                            Text(
                              "$userCollege · $userBranch",
                              style: AppTheme.bodyStyle(fontSize: 12.5, color: const Color(0xFFCFE0D2)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "verifyu.app/${user?.portfolioHandle ?? 'student'}",
                              style: AppTheme.bodyStyle(fontSize: 12.5, color: Colors.white, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.copy, color: Colors.white, size: 15),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Body Contents
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                  children: [
                    // Navigator Insight Card
                    _buildNavigatorInsightCard(oppProvider.opportunities.length),
                    const SizedBox(height: 22),

                    // Quick Actions
                    Text(
                      "QUICK ACTIONS",
                      style: AppTheme.bodyStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.tan),
                    ),
                    const SizedBox(height: 10),
                    _buildQuickActionsGrid(context),
                    const SizedBox(height: 22),

                    // Verified Credentials Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "RECENT ACHIEVEMENTS",
                          style: AppTheme.bodyStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.tan),
                        ),
                        Text(
                          "Verified: ${credProvider.credentials.length}",
                          style: AppTheme.bodyStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.forest),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    credProvider.credentials.isEmpty
                        ? _buildEmptyCredentialsWidget(context)
                        : Column(
                            children: credProvider.credentials.take(3).map((cred) {
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

                    // Recommended Opportunities
                    Text(
                      "RECOMMENDED OPPORTUNITIES",
                      style: AppTheme.bodyStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.tan),
                    ),
                    const SizedBox(height: 10),
                    oppProvider.opportunities.isEmpty
                        ? const Center(child: Padding(padding: EdgeInsets.all(16), child: Text("No recommendations yet. Add credentials to generate matching listings.")))
                        : Column(
                            children: oppProvider.opportunities.take(2).map((opp) {
                              return OpportunityCard(
                                opportunity: opp,
                                onApply: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Applying to ${opp.title} at ${opp.organization}...")),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_credential');
        },
        backgroundColor: AppColors.rose,
        shape: const CircleBorder(),
        elevation: 6,
        child: const Icon(Icons.add, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildNavigatorInsightCard(int oppCount) {
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
                const Icon(Icons.psychology, color: AppColors.gold, size: 22),
                const SizedBox(width: 8),
                Text(
                  "Navigator AI Mentor",
                  style: AppTheme.headingStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.bronze),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "Your profile matches $oppCount job listings! Adding one additional verified project in Flutter or Node.js will boost your matching eligibility by 15%.",
              style: AppTheme.bodyStyle(fontSize: 13, color: AppColors.ink),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "View Recommendations →",
                  style: AppTheme.bodyStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.forest),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    final List<Map<String, dynamic>> actions = [
      {'label': 'Find Opportunities', 'icon': Icons.explore_outlined, 'color': AppColors.forest, 'route': 'opportunities'},
      {'label': 'Skill Gap Analysis', 'icon': Icons.trending_up, 'color': AppColors.gold, 'query': 'analyze my profile'},
      {'label': 'Resume Review', 'icon': Icons.description_outlined, 'color': AppColors.rose, 'query': 'resume review'},
      {'label': 'Interview Prep', 'icon': Icons.forum_outlined, 'color': AppColors.clay, 'query': 'interview prep'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.2,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final act = actions[index];
        return Card(
          elevation: 0,
          color: AppColors.warmWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: AppColors.sand, width: 1),
          ),
          child: InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Triggering ${act['label']}...")),
              );
            },
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: (act['color'] as Color).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(act['icon'] as IconData, size: 16, color: act['color'] as Color),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      act['label'] as String,
                      style: AppTheme.bodyStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyCredentialsWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.sand, width: 1),
      ),
      child: Column(
        children: [
          const Icon(Icons.verified_outlined, size: 36, color: AppColors.tan),
          const SizedBox(height: 10),
          Text(
            "No verified achievements yet.",
            style: AppTheme.bodyStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.ink),
          ),
          const SizedBox(height: 4),
          Text(
            "Upload your certificates to build recruiter trust.",
            textAlign: TextAlign.center,
            style: AppTheme.bodyStyle(fontSize: 12, color: AppColors.tan),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/add_credential'),
            child: Text(
              "+ Add First Achievement",
              style: AppTheme.bodyStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.rose),
            ),
          ),
        ],
      ),
    );
  }
}
