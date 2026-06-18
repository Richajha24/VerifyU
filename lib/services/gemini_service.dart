import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/credential_model.dart';
import '../models/opportunity_model.dart';
import '../config.dart';

class GeminiService {
  final String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

  Future<String> chatWithNavigator({
    required UserModel user,
    required List<CredentialModel> credentials,
    required List<OpportunityModel> opportunities,
    required List<Map<String, dynamic>> history,
    required String newMessage,
  }) async {
    final apiKey = AppConfig.geminiApiKey;

    if (apiKey.isEmpty) {
      // Offline/Local Simulation Mode
      await Future.delayed(const Duration(milliseconds: 1000));
      return _generateSimulatedResponse(user, credentials, opportunities, newMessage);
    }

    try {
      final buffer = StringBuffer();
      buffer.writeln("You are Navigator, an AI-powered student career mentor for VerifyU. You are professional, supportive, encouraging, concise, and mobile-friendly. Never sound robotic or overly formal.");
      buffer.writeln("Your advice is based strictly on the student's verified credentials. Never invent credentials. Always reference their credentials where relevant.");
      buffer.writeln("Student Profile: Name: ${user.name}, College: ${user.college}, Branch: ${user.branch}, Year: ${user.currentYear}, Interests: ${user.careerInterests.join(', ')}, Trust Score: ${user.trustScore}");
      buffer.writeln("Student's Credentials:");
      for (var cred in credentials) {
        buffer.writeln("- Title: ${cred.title}, Issuer: ${cred.organization}, Status: ${cred.status.name}, Score: ${cred.verificationScore}");
      }
      buffer.writeln("Available Opportunities:");
      for (var opp in opportunities) {
        buffer.writeln("- Opp: ${opp.title} at ${opp.organization}, Match: ${opp.matchPercentage}%, Reason: ${opp.matchReasons.join(', ')}");
      }

      final systemPrompt = buffer.toString();

      final List<Map<String, dynamic>> contents = [];

      for (var msg in history) {
        contents.add({
          'role': msg['isUser'] == true ? 'user' : 'model',
          'parts': [
            {'text': msg['message']}
          ]
        });
      }

      contents.add({
        'role': 'user',
        'parts': [
          {'text': "Instructions:\n$systemPrompt\n\nStudent Message: $newMessage"}
        ]
      });

      final response = await http.post(
        Uri.parse('$_baseUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': contents,
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 500,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String text = data['candidates']?[0]['content']?['parts']?[0]['text'] ?? '';
        if (text.isNotEmpty) {
          return text.trim();
        }
      }
      
      print("Gemini API error ${response.statusCode}: ${response.body}");
    } catch (e) {
      print("Gemini connection error: $e");
    }

    return _generateSimulatedResponse(user, credentials, opportunities, newMessage);
  }

  String _generateSimulatedResponse(
    UserModel user,
    List<CredentialModel> credentials,
    List<OpportunityModel> opportunities,
    String message,
  ) {
    final lowerMsg = message.toLowerCase();

    // 1. Internship/Opportunity search
    if (lowerMsg.contains("internship") || lowerMsg.contains("job") || lowerMsg.contains("opportunity") || lowerMsg.contains("find") || lowerMsg.contains("hackathon")) {
      final matches = opportunities.where((o) => o.matchPercentage >= 70).toList();
      if (matches.isEmpty) {
        return "I scanned the available opportunities. Based on your interests in ${user.careerInterests.join(', ')}, there are currently a few listings, but you can make your profile match closer by uploading a Flutter or Web Development credential. Would you like me to help you brainstorm a new project?";
      }
      final first = matches.first;
      final credTitle = credentials.isNotEmpty ? credentials.first.title : 'your profile';
      return "Hi ${user.name.split(' ').first}! Based on your verified credentials (like '$credTitle'), I found a **${first.matchPercentage}% match** with the **${first.title}** at **${first.organization}**.\n\nKey reasons for the match:\n✓ ${first.matchReasons.join('\n✓ ')}\n\nWould you like me to help you write a tailored cover letter or prepare your resume for this?";
    }

    // 2. Profile Analysis / Skill Gap
    if (lowerMsg.contains("profile") || lowerMsg.contains("analyze") || lowerMsg.contains("gap") || lowerMsg.contains("skills")) {
      final verifiedCount = credentials.where((c) => c.status.name == 'verified').length;
      return "Analyzing your profile... You have a strong background in **${user.branch}** at **${user.college}**. You have **$verifiedCount verified credentials**.\n\n**To improve your opportunities, consider adding:**\n- A backend database credential (like Firebase or PostgreSQL)\n- A production app link\n\nWhat skills are you aiming to work on this month?";
    }

    // 3. Resume review
    if (lowerMsg.contains("resume") || lowerMsg.contains("review")) {
      final credOrgs = credentials.isNotEmpty ? credentials.map((c) => c.organization).toSet().join(', ') : 'academic courses';
      return "I'd love to review your resume. Since you have verified achievements from **$credOrgs**, you should showcase these in a dedicated 'Verified Achievements' section with a link to your public VerifyU portfolio (verifyu.app/${user.portfolioHandle}). This builds immediate trust with recruiters. Let's draft your summary section together!";
    }

    // 4. Interview Prep
    if (lowerMsg.contains("interview") || lowerMsg.contains("prep") || lowerMsg.contains("practice")) {
      final primaryInterest = user.careerInterests.isNotEmpty ? user.careerInterests.first : 'Software Engineering';
      return "Let's prepare! Based on your interest in **$primaryInterest**, here is a common technical interview question:\n\n*\"Can you explain the difference between stateful and stateless widgets in Flutter, and when you would use each?\"*\n\nTake a shot at answering, and I will give you feedback!";
    }

    // Default response
    return "Hello ${user.name.split(' ').first}! I'm Navigator, your career companion. I see you're studying at **${user.college}** and are interested in **${user.careerInterests.join(', ')}**. \n\nYou have **${credentials.length} achievements** listed in your portfolio. What career step can we work on together today? (e.g., finding internships, practicing interview questions, or reviewing your profile)";
  }
}
