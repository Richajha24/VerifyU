import 'package:flutter/material.dart';
import '../models/opportunity_model.dart';
import '../models/user_model.dart';
import '../models/credential_model.dart';
import '../services/firestore_service.dart';

class OpportunityProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<OpportunityModel> _opportunities = [];
  bool _isLoading = false;

  List<OpportunityModel> get opportunities => _opportunities;
  bool get isLoading => _isLoading;

  Future<void> fetchOpportunities(UserModel? user, List<CredentialModel> userCredentials) async {
    _isLoading = true;
    notifyListeners();

    var dbList = await _firestoreService.getOpportunities();

    if (dbList.isEmpty) {
      final seedList = _getSeedOpportunities();
      _firestoreService.seedMockOpportunities(seedList);
      dbList = seedList;
    }

    _opportunities = dbList.map((opp) {
      return _calculateDynamicMatch(opp, user, userCredentials);
    }).toList();

    _opportunities.sort((a, b) => b.matchPercentage.compareTo(a.matchPercentage));

    _isLoading = false;
    notifyListeners();
  }

  OpportunityModel _calculateDynamicMatch(
    OpportunityModel opp,
    UserModel? user,
    List<CredentialModel> credentials,
  ) {
    if (user == null) return opp;

    int matchScore = 50; // Base score
    final List<String> reasons = [];

    // 1. Career Interests check
    bool hasInterestMatch = false;
    for (var interest in user.careerInterests) {
      if (opp.title.toLowerCase().contains(interest.toLowerCase()) || 
          opp.category.toLowerCase().contains(interest.toLowerCase())) {
        hasInterestMatch = true;
      }
    }
    if (hasInterestMatch) {
      matchScore += 20;
      reasons.add("Matches your career interests (${user.careerInterests.take(2).join(', ')})");
    }

    // 2. Verified credentials check
    final verifiedCreds = credentials.where((c) => c.status == VerificationStatus.verified);
    bool hasVerifiedMatch = false;
    for (var cred in verifiedCreds) {
      if (cred.category == CredentialCategory.hackathon && opp.category.toLowerCase().contains('hackathon')) {
        hasVerifiedMatch = true;
        reasons.add("✓ Verified Hackathon achievement: ${cred.title}");
      }
      if (cred.title.toLowerCase().contains('flutter') && opp.title.toLowerCase().contains('flutter')) {
        hasVerifiedMatch = true;
        reasons.add("✓ Verified Flutter skill credentials");
      }
      if (cred.title.toLowerCase().contains('cloud') && opp.title.toLowerCase().contains('cloud')) {
        hasVerifiedMatch = true;
        reasons.add("✓ Verified Cloud practitioner credentials");
      }
    }

    if (hasVerifiedMatch) {
      matchScore += 25;
    } else if (verifiedCreds.isNotEmpty) {
      matchScore += 10;
      reasons.add("Backed by your verified portfolio credentials");
    }

    // Match 3: Academic year check
    if (opp.title.toLowerCase().contains('internship') && user.currentYear >= 3) {
      matchScore += 5;
    }

    if (matchScore > 98) matchScore = 98;
    if (matchScore < 40) matchScore = 40;

    return OpportunityModel(
      id: opp.id,
      title: opp.title,
      organization: opp.organization,
      location: opp.location,
      category: opp.category,
      matchPercentage: matchScore,
      matchReasons: reasons.isNotEmpty ? reasons : ["General recommendation based on your academic profile."],
      applyUrl: opp.applyUrl,
    );
  }

  List<OpportunityModel> _getSeedOpportunities() {
    return [
      OpportunityModel(
        id: 'opp-1',
        title: 'Flutter Developer Internship',
        organization: 'Razorpay',
        location: 'Bengaluru (Remote)',
        category: 'Internship',
        matchPercentage: 91,
        matchReasons: ['✓ Flutter Credential', '✓ Firebase Skill', '✓ App Development Interest'],
        applyUrl: 'https://razorpay.com/jobs',
      ),
      OpportunityModel(
        id: 'opp-2',
        title: 'Smart India Hackathon 2026',
        organization: 'Ministry of Education',
        location: 'All India',
        category: 'Hackathon',
        matchPercentage: 85,
        matchReasons: ['✓ Problem Solving Skill', '✓ Hackathon Experience interest'],
        applyUrl: 'https://sih.gov.in',
      ),
      OpportunityModel(
        id: 'opp-3',
        title: 'Junior Machine Learning Research Fellow',
        organization: 'IISc Bangalore',
        location: 'Bengaluru',
        category: 'Research Program',
        matchPercentage: 74,
        matchReasons: ['✓ Academic Branch matches CSE', '✓ AI/ML Career Interest'],
        applyUrl: 'https://iisc.ac.in',
      ),
      OpportunityModel(
        id: 'opp-4',
        title: 'Google Generation Scholarship 2026',
        organization: 'Google',
        location: 'Asia Pacific',
        category: 'Scholarship',
        matchPercentage: 88,
        matchReasons: ['✓ High Trust Score validation', '✓ Academic Year matches Year 3/4'],
        applyUrl: 'https://buildyourfuture.withgoogle.com',
      ),
      OpportunityModel(
        id: 'opp-5',
        title: 'UI/UX Design Competition',
        organization: 'Adobe India',
        location: 'Remote',
        category: 'Competition',
        matchPercentage: 62,
        matchReasons: ['✓ UI/UX Interest chip', '✓ Design Portfolio snapshot'],
        applyUrl: 'https://adobe.com/india',
      ),
    ];
  }
}
