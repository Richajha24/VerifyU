import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class UserProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  UserModel? _userModel;
  bool _isLoading = false;

  UserModel? get user => _userModel;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _authService.currentUser != null;

  UserProvider() {
    _init();
  }

  void _init() {
    _authService.authStateChanges.listen((fb.User? firebaseUser) async {
      if (firebaseUser != null) {
        _isLoading = true;
        notifyListeners();
        _userModel = await _firestoreService.getUser(firebaseUser.uid);
        _isLoading = false;
        notifyListeners();
      } else {
        _userModel = null;
        notifyListeners();
      }
    });
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();
    final fbUser = await _authService.signInWithGoogle();
    if (fbUser != null) {
      _userModel = await _firestoreService.getUser(fbUser.uid);
    }
    _isLoading = false;
    notifyListeners();
    return fbUser != null;
  }

  Future<void> registerUser({
    required String name,
    required String college,
    required String branch,
    required int year,
    required int gradYear,
    required String city,
    required List<String> interests,
    required String photoUrl,
  }) async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) return;

    _isLoading = true;
    notifyListeners();

    final portfolioHandle = name.toLowerCase().replaceAll(RegExp(r'\s+'), '-');
    final newUser = UserModel(
      id: currentUser.uid,
      name: name,
      email: currentUser.email ?? 'student@verifyu.app',
      photoUrl: photoUrl.isNotEmpty ? photoUrl : 'https://api.dicebear.com/7.x/adventurer/svg?seed=$name',
      college: college,
      branch: branch,
      currentYear: year,
      graduationYear: gradYear,
      city: city,
      careerInterests: interests,
      trustScore: 0,
      portfolioHandle: portfolioHandle,
    );

    await _firestoreService.saveUser(newUser);
    _userModel = newUser;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateTrustScore(int newScore) async {
    if (_userModel == null) return;
    _userModel = _userModel!.copyWith(trustScore: newScore);
    await _firestoreService.saveUser(_userModel!);
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _userModel = null;
    notifyListeners();
  }
}
