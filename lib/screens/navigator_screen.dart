import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/credential_provider.dart';
import '../providers/opportunity_provider.dart';
import '../providers/navigator_provider.dart';
import '../utils/theme.dart';
import '../widgets/navigator_chip.dart';

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({Key? key}) : super(key: key);

  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  final List<String> _suggestedChips = [
    'Find internships',
    'Analyze my profile',
    'Resume review',
    'Skill gap analysis',
    'Interview prep',
    'Find hackathons',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final credProvider = Provider.of<CredentialProvider>(context, listen: false);
    final oppProvider = Provider.of<OpportunityProvider>(context, listen: false);
    final navProvider = Provider.of<NavigatorProvider>(context, listen: false);

    if (userProvider.user != null) {
      navProvider.sendMessage(
        user: userProvider.user!,
        credentials: credProvider.credentials,
        opportunities: oppProvider.opportunities,
        text: text,
      ).then((_) {
        // Scroll down after response arrives
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      });

      _messageController.clear();
      // Scroll down after user message is added
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    }
  }

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigatorProvider>(context);

    // Trigger auto-scroll on load/new messages
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              decoration: const BoxDecoration(
                color: AppColors.warmWhite,
                border: Border(bottom: BorderSide(color: AppColors.sand, width: 1)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.gold.withOpacity(0.12),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.sand2, width: 1.5),
                    ),
                    child: const Icon(Icons.psychology, color: AppColors.gold, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Navigator AI Mentor",
                        style: AppTheme.headingStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.bronze),
                      ),
                      Text(
                        "Always references your verified credentials",
                        style: AppTheme.bodyStyle(fontSize: 11, color: AppColors.tan),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppColors.rose),
                    onPressed: () {
                      final userProvider = Provider.of<UserProvider>(context, listen: false);
                      if (userProvider.user != null) {
                        navProvider.clearChat(userProvider.user!.id);
                      }
                    },
                  ),
                ],
              ),
            ),

            // 2. Chat Area
            Expanded(
              child: navProvider.isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.forest))
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16.0),
                      itemCount: navProvider.messages.length,
                      itemBuilder: (context, index) {
                        final msg = navProvider.messages[index];
                        final isUser = msg['isUser'] == true;

                        return _buildChatBubble(msg['message'] as String, isUser);
                      },
                    ),
            ),

            // 3. Typing Indicator
            if (navProvider.isTyping)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      "Navigator is typing...",
                      style: AppTheme.bodyStyle(
                        fontSize: 12,
                        color: AppColors.tan,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

            // 4. Suggested Chips
            Container(
              height: 48,
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _suggestedChips.length,
                itemBuilder: (context, index) {
                  final chipText = _suggestedChips[index];
                  return NavigatorChip(
                    label: chipText,
                    onTap: () => _sendMessage(chipText),
                  );
                },
              ),
            ),

            // 5. Input Bar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              color: AppColors.ivory,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: AppTheme.bodyStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Ask Navigator about your career goals...",
                        hintStyle: AppTheme.bodyStyle(fontSize: 13.5, color: AppColors.tan),
                        filled: true,
                        fillColor: AppColors.warmWhite,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: AppColors.sand, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: AppColors.forest, width: 1.5),
                        ),
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.forest,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 18),
                      onPressed: () => _sendMessage(_messageController.text),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.76,
        ),
        decoration: BoxDecoration(
          color: isUser ? AppColors.ink : AppColors.warmWhite,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(16),
          ),
          border: isUser
              ? null
              : Border.all(color: AppColors.sand, width: 1),
        ),
        child: Text(
          text,
          style: AppTheme.bodyStyle(
            fontSize: 13.5,
            color: isUser ? Colors.white : AppColors.ink,
          ),
        ),
      ),
    );
  }
}
