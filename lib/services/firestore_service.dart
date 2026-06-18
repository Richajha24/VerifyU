import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/credential_model.dart';
import '../models/opportunity_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Local memory cache/mock database to guarantee immediate functionality
  static final Map<String, Map<String, dynamic>> _mockUsers = {};
  static final Map<String, Map<String, dynamic>> _mockCredentials = {};
  static final Map<String, Map<String, dynamic>> _mockOpportunities = {};

  // User methods
  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!, doc.id);
      }
    } catch (e) {
      print("Firestore getUser failed: $e. Falling back to local cache.");
    }
    
    if (_mockUsers.containsKey(uid)) {
      return UserModel.fromJson(_mockUsers[uid]!, uid);
    }
    return null;
  }

  Future<void> saveUser(UserModel user) async {
    try {
      await _db.collection('users').doc(user.id).set(user.toJson());
    } catch (e) {
      print("Firestore saveUser failed: $e. Saving to local cache.");
    }
    _mockUsers[user.id] = user.toJson();
  }

  // Credentials methods
  Future<List<CredentialModel>> getCredentials(String uid) async {
    try {
      final querySnapshot = await _db.collection('credentials').where('userId', isEqualTo: uid).get();
      return querySnapshot.docs.map((doc) => CredentialModel.fromJson(doc.data(), doc.id)).toList();
    } catch (e) {
      print("Firestore getCredentials failed: $e. Loading from local cache.");
    }
    
    return _mockCredentials.values
        .where((data) => data['userId'] == uid)
        .map((data) => CredentialModel.fromJson(data, data['id'] ?? ''))
        .toList();
  }

  Future<void> saveCredential(CredentialModel credential) async {
    try {
      await _db.collection('credentials').doc(credential.id).set(credential.toJson());
    } catch (e) {
      print("Firestore saveCredential failed: $e. Saving to local cache.");
    }
    _mockCredentials[credential.id] = {
      ...credential.toJson(),
      'id': credential.id,
    };
  }

  // Opportunities methods
  Future<List<OpportunityModel>> getOpportunities() async {
    try {
      final querySnapshot = await _db.collection('opportunities').get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.map((doc) => OpportunityModel.fromJson(doc.data(), doc.id)).toList();
      }
    } catch (e) {
      print("Firestore getOpportunities failed: $e. Loading from local cache.");
    }
    
    return _mockOpportunities.values.map((data) => OpportunityModel.fromJson(data, data['id'] ?? '')).toList();
  }

  Future<void> saveOpportunity(OpportunityModel opp) async {
    try {
      await _db.collection('opportunities').doc(opp.id).set(opp.toJson());
    } catch (e) {
      print("Firestore saveOpportunity failed: $e");
    }
    _mockOpportunities[opp.id] = {
      ...opp.toJson(),
      'id': opp.id,
    };
  }

  // Seed opportunities for demo
  void seedMockOpportunities(List<OpportunityModel> list) {
    for (var opp in list) {
      _mockOpportunities[opp.id] = {
        ...opp.toJson(),
        'id': opp.id,
      };
      saveOpportunity(opp);
    }
  }

  // Chat History methods
  Future<List<Map<String, dynamic>>> getChatHistory(String uid) async {
    try {
      final snapshot = await _db.collection('navigator_history')
          .doc(uid)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Firestore getChatHistory failed: $e");
      return [];
    }
  }

  Future<void> saveChatMessage(String uid, Map<String, dynamic> msg) async {
    try {
      await _db.collection('navigator_history')
          .doc(uid)
          .collection('messages')
          .add(msg);
    } catch (e) {
      print("Firestore saveChatMessage failed: $e");
    }
  }
}
