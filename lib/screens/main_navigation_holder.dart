import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/credential_provider.dart';
import '../providers/opportunity_provider.dart';
import '../providers/navigator_provider.dart';
import '../utils/theme.dart';
import 'home_dashboard.dart';
import 'portfolio_screen.dart';
import 'navigator_screen.dart';
import 'opportunities_screen.dart';
import 'profile_screen.dart';

class MainNavigationHolder extends StatefulWidget {
  const MainNavigationHolder({Key? key}) : super(key: key);

  @override
  State<MainNavigationHolder> createState() => _MainNavigationHolderState();
}

class _MainNavigationHolderState extends State<MainNavigationHolder> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeDashboard(),
    const PortfolioScreen(),
    const NavigatorScreen(),
    const OpportunitiesScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user != null) {
      final userId = userProvider.user!.id;
      
      // Fetch credentials, opportunities and history in sequence
      Provider.of<CredentialProvider>(context, listen: false)
          .fetchCredentials(userId)
          .then((_) {
            final credProvider = Provider.of<CredentialProvider>(context, listen: false);
            Provider.of<OpportunityProvider>(context, listen: false)
                .fetchOpportunities(userProvider.user, credProvider.credentials);
            
            // Sync user trust score with average
            if (userProvider.user!.trustScore != credProvider.averageTrustScore) {
              userProvider.updateTrustScore(credProvider.averageTrustScore);
            }
          });
      
      Provider.of<NavigatorProvider>(context, listen: false).fetchHistory(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        height: 84,
        decoration: const BoxDecoration(
          color: AppColors.warmWhite,
          border: Border(
            top: BorderSide(color: AppColors.sand, width: 1.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home_outlined, Icons.home, "home"),
            _buildNavItem(1, Icons.badge_outlined, Icons.badge, "portfolio"),
            _buildCentralNavItem(2, Icons.psychology_outlined, Icons.psychology, "Navigator"),
            _buildNavItem(3, Icons.explore_outlined, Icons.explore, "opportunities"),
            _buildNavItem(4, Icons.person_outline, Icons.person, "profile"),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData outlineIcon, IconData filledIcon, String label) {
    final isActive = _currentIndex == index;
    final color = isActive ? AppColors.forest : AppColors.tan;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentIndex = index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? filledIcon : outlineIcon,
              color: color,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTheme.bodyStyle(
                fontSize: 10.5,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCentralNavItem(int index, IconData outlineIcon, IconData filledIcon, String label) {
    final isActive = _currentIndex == index;
    final color = isActive ? AppColors.gold : AppColors.bronze;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentIndex = index),
        child: Transform.translate(
          offset: const Offset(0, -6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.gold.withOpacity(0.12) : AppColors.warmWhite,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActive ? AppColors.gold : AppColors.sand2,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.ink.withOpacity(0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  isActive ? filledIcon : outlineIcon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: AppTheme.bodyStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
