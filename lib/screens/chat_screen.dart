import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/chat_bubble.dart';
import '../widgets/loading_skeleton.dart';
import '../services/quant_space_api.dart'; // Integrating the Python Backend Wrapper
import '../core/theme/app_theme.dart';     // Enforcing standard pure-black/orange-red aesthetic
import 'history_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

import '../core/models/chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();


  final QuantSpaceApi _api = QuantSpaceApi();

  bool _isLoading = true;
  bool _isReplyLoading = false;
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  String _selectedModel = 'Grok 4.1';
  String _selectedModelId = 'groq/llama-3.1-70b-versatile'; // Default model ID routing
  String _selectedFolder = 'General 💬';

  //  LiteLLM add kiya hai yaha api address change kar dena
  final List<Map<String, String>> _aiModels = [
    {'name': 'Grok 4.1', 'icon': '🤖', 'id': 'groq/llama-3.1-70b-versatile'}, // Usually proxied through Groq/Llama
    {'name': 'GPT-4o', 'icon': '🧠', 'id': 'openai/gpt-4o'},
    {'name': 'Claude 3.5', 'icon': '📚', 'id': 'openrouter/anthropic/claude-3.5-sonnet'},
    {'name': 'Gemini 2.0', 'icon': '⭐', 'id': 'gemini/gemini-1.5-flash'},
    {'name': 'Llama 3.1', 'icon': '🐪', 'id': 'groq/llama-3.1-8b-instant'},
  ];

  final List<String> _folders = [
    'Finance 💰',
    'Research 🔬',
    'Technology 💻',
    'Crypto ₿',
    'Incognito 🕶️',
    'Academics 📖',
    'General 💬',
    'Coding 🐛',
  ];

  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadInitialChat();
  }

  Future<void> _loadInitialChat() async {
    // Quick startup fake-load (can be replaced with genuine history API fetch later)
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() {
      _messages.add(
        ChatMessage(
          message: "Initialization complete. Connected to QuantSpace.Ai Gateway. How can I assist you today?",
          isUser: false,
          timestamp: DateTime.now().subtract(const Duration(seconds: 2)),
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

  // --- INTEGRATION: CONNECTING UI TO PYTHON BACKEND ---
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
          message: userMessage.isNotEmpty ? userMessage : "Shared an image",
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
      // Hits the QuantSpace_backend_web FastAPI server
      final response = await _api.chat(
        userMessage,
        model: _selectedModelId,
        images: base64Images,
      );

      if (!mounted) return;

      setState(() {
        _messages.add(
          ChatMessage(
            message: response['content'] ?? 'An error occurred fetching response constraints.',
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
            message: "🚨 Server Offline: Failed to communicate with QuantSpace Python Backend. Please ensure `uvicorn main:app` is actively running locally.",
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

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _changeFolder(String folder) {
    setState(() => _selectedFolder = folder);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Switched to $folder folder', style: GoogleFonts.outfit(fontSize: 13)),
        backgroundColor: AppTheme.primaryRed,
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlack, // Integrated AppTheme
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: AppTheme.textPrimary,
              size: 20,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primaryRed.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.smart_toy,
                color: AppTheme.primaryRed,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'QuantSpace.Ai',
                  style: GoogleFonts.orbitron(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  _selectedModel,
                  style: GoogleFonts.outfit(
                    color: AppTheme.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: AppTheme.primaryRed),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HistoryScreen(),
              ),
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppTheme.primaryRed),
            color: AppTheme.surfaceDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: _changeFolder,
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                enabled: false,
                child: Row(
                  children: [
                    const Icon(
                      Icons.folder,
                      color: AppTheme.primaryRed,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        _selectedFolder,
                        style: GoogleFonts.outfit(color: AppTheme.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
              ..._folders.map(
                    (folder) => PopupMenuItem<String>(
                  value: folder,
                  child: Text(
                    folder,
                    style: GoogleFonts.outfit(color: AppTheme.textPrimary),
                  ),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _aiModels.map((model) {
                  final isSelected = _selectedModel == model['name'];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedModel = model['name']!;
                        _selectedModelId = model['id']!; // Route to correct backend brain
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryRed.withOpacity(0.2)
                            : AppTheme.surfaceDark,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryRed
                              : Colors.transparent,
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
                            style: GoogleFonts.outfit(color: AppTheme.textPrimary, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
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
                    widthFactor: 0.58,
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: const BoxDecoration(
              color: AppTheme.surfaceDark,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy,
              color: AppTheme.primaryRed,
              size: 64,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Start a conversation',
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Ask me anything regarding $_selectedFolder',
            style: GoogleFonts.outfit(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_selectedImage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
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
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add_photo_alternate_outlined, color: AppTheme.textSecondary),
                onPressed: _pickImage,
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  enabled: !_isReplyLoading,
                  style: GoogleFonts.outfit(color: AppTheme.textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: _isReplyLoading
                        ? '$_selectedModel is thinking...'
                        : 'Message $_selectedModel...',
                    hintStyle: GoogleFonts.outfit(
                      color: AppTheme.textSecondary.withOpacity(0.5),
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: AppTheme.surfaceMedium,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  maxLines: null,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              FloatingActionButton(
                mini: true,
                onPressed: _isReplyLoading ? null : _sendMessage,
                backgroundColor: AppTheme.primaryRed,
                elevation: 4,
                child: _isReplyLoading
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Icon(Icons.send, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
