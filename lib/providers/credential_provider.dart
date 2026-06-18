import 'dart:io';
import 'package:flutter/material.dart';
import '../models/credential_model.dart';
import '../services/firestore_service.dart';
import '../services/verification_service.dart';

class CredentialProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final VerificationService _verificationService = VerificationService();

  List<CredentialModel> _credentials = [];
  bool _isLoading = false;

  // Multi-step addition states
  String? _tempTitle;
  String? _tempOrganization;
  String? _tempDate;
  CredentialCategory _tempCategory = CredentialCategory.other;
  String? _tempDescription;
  File? _tempCertificateFile;
  File? _tempProofFile;

  VerificationResult? _tempVerificationResult;

  List<CredentialModel> get credentials => _credentials;
  bool get isLoading => _isLoading;

  String get tempTitle => _tempTitle ?? '';
  String get tempOrganization => _tempOrganization ?? '';
  String get tempDate => _tempDate ?? '';
  CredentialCategory get tempCategory => _tempCategory;
  String get tempDescription => _tempDescription ?? '';
  File? get tempCertificateFile => _tempCertificateFile;
  File? get tempProofFile => _tempProofFile;
  VerificationResult? get tempVerificationResult => _tempVerificationResult;

  void setStep1Details({
    required String title,
    required String organization,
    required String date,
    required CredentialCategory category,
    required String description,
  }) {
    _tempTitle = title;
    _tempOrganization = organization;
    _tempDate = date;
    _tempCategory = category;
    _tempDescription = description;
    notifyListeners();
  }

  Future<void> uploadCertificate(File file, String userName) async {
    _tempCertificateFile = file;
    _isLoading = true;
    notifyListeners();

    _tempVerificationResult = await _verificationService.verifyCredential(
      imageFile: file,
      expectedTitle: _tempTitle ?? '',
      expectedOrganization: _tempOrganization ?? '',
      expectedDate: _tempDate ?? '',
      expectedName: userName,
    );

    _isLoading = false;
    notifyListeners();
  }

  void uploadProof(File file) {
    _tempProofFile = file;
    notifyListeners();
  }

  Future<void> saveCredential(String userId) async {
    if (_tempTitle == null || _tempVerificationResult == null) return;

    _isLoading = true;
    notifyListeners();

    // Unique verification ID concept e.g. VU-2026-XXXXX
    final yearStr = DateTime.now().year.toString();
    final randomId = (10000 + DateTime.now().millisecond % 90000).toString();
    final id = "VU-$yearStr-$randomId";

    final credential = CredentialModel(
      id: id,
      userId: userId,
      title: _tempTitle!,
      organization: _tempOrganization ?? '',
      dateAchieved: _tempDate ?? '',
      category: _tempCategory,
      description: _tempDescription ?? '',
      certificateUrl: _tempCertificateFile?.path ?? '',
      proofUrl: _tempProofFile?.path ?? '',
      verificationScore: _tempVerificationResult!.totalScore,
      ocrResult: {
        'passedChecks': _tempVerificationResult!.passedChecks,
        'failedChecks': _tempVerificationResult!.failedChecks,
        'scannedText': _tempVerificationResult!.scannedText,
        'ocrScore': _tempVerificationResult!.ocrScore,
      },
      aiDetectionResult: {
        'authenticityScore': _tempVerificationResult!.authenticityScore,
      },
      status: _tempVerificationResult!.status == 'verified' 
          ? VerificationStatus.verified 
          : _tempVerificationResult!.status == 'flagged' 
              ? VerificationStatus.flagged 
              : VerificationStatus.reviewNeeded,
    );

    await _firestoreService.saveCredential(credential);
    _credentials.add(credential);

    // Reset details
    _tempTitle = null;
    _tempOrganization = null;
    _tempDate = null;
    _tempCategory = CredentialCategory.other;
    _tempDescription = null;
    _tempCertificateFile = null;
    _tempProofFile = null;
    _tempVerificationResult = null;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCredentials(String userId) async {
    _isLoading = true;
    notifyListeners();
    _credentials = await _firestoreService.getCredentials(userId);
    _isLoading = false;
    notifyListeners();
  }

  int get averageTrustScore {
    if (_credentials.isEmpty) return 0;
    final total = _credentials.map((c) => c.verificationScore).reduce((a, b) => a + b);
    return (total / _credentials.length).round();
  }

  @override
  void dispose() {
    _verificationService.dispose();
    super.dispose();
  }
}
