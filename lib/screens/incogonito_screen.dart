import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

import '../core/theme/app_theme.dart';
import '../core/models/chat_message.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/loading_skeleton.dart';
import '../services/quant_space_api.dart';

class IncogonitoScreen extends StatefulWidget {
  const IncogonitoScreen({super.key});

  @override
  State<IncogonitoScreen> createState() => _IncogonitoScreenState();
}

class _IncogonitoScreenState extends State<IncogonitoScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final QuantSpaceApi _api = QuantSpaceApi();
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = true;
  bool _isReplyLoading = false;
  bool _privacyShieldEnabled = true;
  bool _temporarySession = true;
  XFile? _selectedImage;

  String _selectedModel = 'Grok 4.1';
  String _selectedModelId = 'groq/llama-3.1-70b-versatile';

  final List<Map<String, String>> _aiModels = [
    {'name': 'Grok 4.1', 'icon': '🤖', 'id': 'groq/llama-3.1-70b-versatile'},
    {'name': 'GPT-4o', 'icon': '🧠', 'id': 'openai/gpt-4o'},
    {'name': 'Claude 3.5', 'icon': '📚', 'id': 'openrouter/anthropic/claude-3.5-sonnet'},
    {'name': 'Gemini 2.0', 'icon': '⭐', 'id': 'gemini/gemini-1.5-flash'},
    {'name': 'Llama 3.1', 'icon': '🐪', 'id': 'groq/llama-3.1-8b-instant'},
  ];

  final List<ChatMessage> _messages = [];

  // Consistent incognito accent color to differentiate from normal Chat
  static const Color incognitoAccent = Color(0xFFCFD8DC);

  @override
  void initState() {
    super.initState();
    _loadInitialChat();
  }

  Future<void> _loadInitialChat() async {
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      _messages.add(
        ChatMessage(
          message:
          "Incognito mode is on. This session is private, temporary, and designed for sensitive conversations. No history is stored on your device.",
          isUser: false,
          timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        ),
      );
      _isLoading = false;
    });

    _scrollToBottom();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final userMessage = _messageController.text.trim();
    if (userMessage.isEmpty && _selectedImage == null || _isReplyLoading) return;

    List<String>? base64Images;
    String? localImagePath = _selectedImage?.path;

    if (_selectedImage != null) {
      final bytes = await _selectedImage!.readAsBytes();
      base64Images = [base64Encode(bytes)];
    }

    setState(() {
      _messages.add(
        ChatMessage(
          message: userMessage.isNotEmpty ? userMessage : "Shared an image privately",
          isUser: true,
          timestamp: DateTime.now(),
          imagePath: localImagePath,
        ),
      );
      _isReplyLoading = true;
      _selectedImage = null;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      final response = await _api.chat(
        userMessage,
        model: _selectedModelId,
        images: base64Images,
      );

      if (!mounted) return;

      setState(() {
        _messages.add(
          ChatMessage(
            message: response['content'] ?? 'Privacy layer blocked the response content.',
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(
          ChatMessage(
            message: "🚨 Privacy Connection Error: Could not reach the secure backend gateway.",
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _isReplyLoading = false;
        });
        _scrollToBottom();
      }
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
    );
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  void _clearSession() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Clear incognito session?',
          style: GoogleFonts.outfit(color: AppTheme.textPrimary, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'This will remove all messages from this temporary session.',
          style: GoogleFonts.outfit(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.outfit(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: incognitoAccent,
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(_messages.clear);
            },
            child: Text('Clear', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildPrivacyBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceMedium,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: incognitoAccent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.visibility_off_rounded,
              color: incognitoAccent,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Incognito is active',
                  style: GoogleFonts.outfit(
                    color: AppTheme.textPrimary,
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _temporarySession
                      ? 'Messages stay in this temporary session only.'
                      : 'Temporary mode is disabled for this demo session.',
                  style: GoogleFonts.outfit(
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModelSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _aiModels.map((model) {
            final isSelected = _selectedModel == model['name'];

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedModel = model['name']!;
                  _selectedModelId = model['id']!;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? incognitoAccent.withOpacity(0.14)
                      : AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isSelected
                        ? incognitoAccent.withOpacity(0.45)
                        : Colors.white.withOpacity(0.05),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      model['icon']!,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      model['name']!,
                      style: GoogleFonts.outfit(
                        color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
                        fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSecurityChips() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _chip(
            icon: Icons.timer_outlined,
            label: _temporarySession ? 'Temporary' : 'Persistent',
          ),
          _chip(
            icon: Icons.shield_moon_outlined,
            label: _privacyShieldEnabled ? 'Shield On' : 'Shield Off',
          ),
          _chip(
            icon: Icons.history_toggle_off,
            label: 'No History',
          ),
        ],
      ),
    );
  }

  Widget _chip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: incognitoAccent),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.outfit(
              color: AppTheme.textSecondary,
              fontSize: 13.2,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.surfaceDark,
                border: Border.all(
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
              child: const Icon(
                Icons.visibility_off_rounded,
                color: incognitoAccent,
                size: 58,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'Private conversation ready',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                color: AppTheme.textPrimary,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Start chatting in incognito mode. This screen is designed for temporary, privacy-first conversations.',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                color: AppTheme.textSecondary,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(26),
          topRight: Radius.circular(26),
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_selectedImage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0, left: 8),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.file(
                      File(_selectedImage!.path),
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: -4,
                    right: -4,
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedImage = null),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              _actionIcon(
                icon: Icons.add_photo_alternate_outlined,
                onTap: _pickImage,
              ),
              _actionIcon(
                icon: Icons.delete_outline_rounded,
                onTap: _clearSession,
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  enabled: !_isReplyLoading,
                  style: GoogleFonts.outfit(color: AppTheme.textPrimary),
                  cursorColor: incognitoAccent,
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: _isReplyLoading
                        ? '$_selectedModel is generating privately...'
                        : 'Send a private message...',
                    hintStyle: GoogleFonts.outfit(color: Colors.white38),
                    filled: true,
                    fillColor: AppTheme.surfaceMedium,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 10),
              FloatingActionButton(
                mini: true,
                elevation: 0,
                onPressed: _isReplyLoading ? null : _sendMessage,
                backgroundColor: incognitoAccent,
                child: _isReplyLoading
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.black,
                  ),
                )
                    : const Icon(
                  Icons.send_rounded,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.lock_clock_outlined,
                size: 15,
                color: Colors.white.withOpacity(0.55),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _temporarySession
                      ? 'Temporary session enabled • messages can be discarded anytime'
                      : 'Temporary session disabled',
                  style: GoogleFonts.outfit(
                    color: Colors.white.withOpacity(0.55),
                    fontSize: 12.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionIcon({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceMedium,
        borderRadius: BorderRadius.circular(14),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          icon,
          color: incognitoAccent,
          size: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: AppTheme.textPrimary,
                size: 18,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: incognitoAccent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.visibility_off_rounded,
                color: incognitoAccent,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'INCOGNITO',
                  style: GoogleFonts.orbitron(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  _selectedModel,
                  style: GoogleFonts.outfit(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Temporary session',
            onPressed: () {
              setState(() => _temporarySession = !_temporarySession);
            },
            icon: Icon(
              _temporarySession
                  ? Icons.timer_off_outlined
                  : Icons.timer_outlined,
              color: incognitoAccent,
            ),
          ),
          PopupMenuButton<String>(
            color: AppTheme.surfaceDark,
            icon: const Icon(
              Icons.more_vert,
              color: incognitoAccent,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            onSelected: (value) {
              if (value == 'clear') {
                _clearSession();
              } else if (value == 'shield') {
                setState(() {
                  _privacyShieldEnabled = !_privacyShieldEnabled;
                });
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'shield',
                child: Text(
                  'Toggle Privacy Shield',
                  style: GoogleFonts.outfit(color: AppTheme.textPrimary),
                ),
              ),
              PopupMenuItem(
                value: 'clear',
                child: Text(
                  'Clear Session',
                  style: GoogleFonts.outfit(color: AppTheme.textPrimary),
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const ChatLoadingSkeleton()
          : Column(
        children: [
          _buildPrivacyBanner(),
          _buildModelSelector(),
          _buildSecurityChips(),
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _messages.length + (_isReplyLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isReplyLoading && index == _messages.length) {
                  return const ChatBubbleSkeleton(
                    isUser: false,
                    widthFactor: 0.56,
                  );
                }

                return ChatBubble(message: _messages[index]);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }
}
