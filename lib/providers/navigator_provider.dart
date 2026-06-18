import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/credential_model.dart';
import '../models/opportunity_model.dart';
import '../services/gemini_service.dart';
import '../services/firestore_service.dart';

class NavigatorProvider with ChangeNotifier {
  final GeminiService _geminiService = GeminiService();
  final FirestoreService _firestoreService = FirestoreService();

  List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;
  bool _isLoading = false;

  List<Map<String, dynamic>> get messages => _messages;
  bool get isTyping => _isTyping;
  bool get isLoading => _isLoading;

  Future<void> fetchHistory(String userId) async {
    _isLoading = true;
    notifyListeners();

    final dbHistory = await _firestoreService.getChatHistory(userId);
    if (dbHistory.isNotEmpty) {
      _messages = dbHistory.map((item) {
        return {
          'message': item['message'] ?? '',
          'isUser': item['isUser'] ?? false,
          'timestamp': item['timestamp'] != null 
              ? DateTime.parse(item['timestamp'].toString()) 
              : DateTime.now(),
        };
      }).toList();
    } else {
      _messages = [
        {
          'message': "Hi! I'm Navigator, your career mentor. I use your verified credentials as context to help you find matching opportunities, review your resume, analyze skill gaps, or practice interviews. What should we do today?",
          'isUser': false,
          'timestamp': DateTime.now(),
        }
      ];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendMessage({
    required UserModel user,
    required List<CredentialModel> credentials,
    required List<OpportunityModel> opportunities,
    required String text,
  }) async {
    if (text.trim().isEmpty) return;

    final userMsg = {
      'message': text,
      'isUser': true,
      'timestamp': DateTime.now(),
    };
    _messages.add(userMsg);
    notifyListeners();

    // Non-blocking save to database
    _firestoreService.saveChatMessage(user.id, {
      'message': text,
      'isUser': true,
      'timestamp': DateTime.now().toIso8601String(),
    });

    _isTyping = true;
    notifyListeners();

    // Request Gemini response
    final response = await _geminiService.chatWithNavigator(
      user: user,
      credentials: credentials,
      opportunities: opportunities,
      history: _messages.sublist(0, _messages.length - 1),
      newMessage: text,
    );

    _isTyping = false;
    final modelMsg = {
      'message': response,
      'isUser': false,
      'timestamp': DateTime.now(),
    };
    _messages.add(modelMsg);
    notifyListeners();

    _firestoreService.saveChatMessage(user.id, {
      'message': response,
      'isUser': false,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  void clearChat(String userId) {
    _messages = [
      {
        'message': "Chat history cleared. I'm ready to help you analyze your portfolio or guide your career search. Ask me anything!",
        'isUser': false,
        'timestamp': DateTime.now(),
      }
    ];
    notifyListeners();
  }
}
