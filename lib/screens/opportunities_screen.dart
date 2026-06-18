import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/credential_provider.dart';
import '../providers/opportunity_provider.dart';
import '../utils/theme.dart';
import '../widgets/opportunity_card.dart';

class OpportunitiesScreen extends StatefulWidget {
  const OpportunitiesScreen({Key? key}) : super(key: key);

  @override
  State<OpportunitiesScreen> createState() => _OpportunitiesScreenState();
}

class _OpportunitiesScreenState extends State<OpportunitiesScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Internship',
    'Hackathon',
    'Scholarship',
    'Research Program',
    'Competition',
  ];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final credProvider = Provider.of<CredentialProvider>(context);
    final oppProvider = Provider.of<OpportunityProvider>(context);

    // Filter opportunities list
    final filteredOpportunities = _selectedCategory == 'All'
        ? oppProvider.opportunities
        : oppProvider.opportunities
            .where((opp) => opp.category.toLowerCase() == _selectedCategory.toLowerCase())
            .toList();

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(22, 26, 22, 12),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Discover Opportunities",
                    style: AppTheme.headingStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "AI-ranked roles and programs matched directly to your verified achievements and interests.",
                    style: AppTheme.bodyStyle(fontSize: 13, color: AppColors.tan),
                  ),
                ],
              ),
            ),

            // Categories horizontal scroller
            Container(
              height: 48,
              padding: const EdgeInsets.only(left: 22, bottom: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat;

                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedCategory = cat);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.forest : AppColors.warmWhite,
                        border: Border.all(
                          color: isSelected ? AppColors.forest : AppColors.sand,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        cat,
                        style: AppTheme.bodyStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.ink,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Opportunities List
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  if (userProvider.user != null) {
                    await oppProvider.fetchOpportunities(
                      userProvider.user,
                      credProvider.credentials,
                    );
                  }
                },
                color: AppColors.forest,
                child: oppProvider.isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.forest))
                    : filteredOpportunities.isEmpty
                        ? _buildEmptyOpportunitiesWidget()
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                            itemCount: filteredOpportunities.length,
                            itemBuilder: (context, index) {
                              final opp = filteredOpportunities[index];
                              return OpportunityCard(
                                opportunity: opp,
                                onApply: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Redirecting to verify eligibility and apply for ${opp.title}...")),
                                  );
                                },
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyOpportunitiesWidget() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      children: [
        const Icon(Icons.search_off_outlined, size: 48, color: AppColors.tan),
        const SizedBox(height: 14),
        Center(
          child: Text(
            "No opportunities found in this category.",
            style: AppTheme.bodyStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            "Try adding more credentials to open up additional suggestions.",
            textAlign: TextAlign.center,
            style: AppTheme.bodyStyle(fontSize: 12, color: AppColors.tan),
          ),
        ),
      ],
    );
  }
}
