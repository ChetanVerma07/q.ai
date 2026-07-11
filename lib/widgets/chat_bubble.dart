import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../core/theme/app_theme.dart';
import 'dart:io';

import '../core/models/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment:
        message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!message.isUser) _buildAvatar(),
              const SizedBox(width: 12),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: message.isUser
                        ? AppTheme.primaryRed.withOpacity(0.9)
                        : AppTheme.surfaceDark,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(message.isUser ? 20 : 0),
                      bottomRight: Radius.circular(message.isUser ? 0 : 20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message.imagePath != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(message.imagePath!),
                              fit: BoxFit.cover,
                              width: 200,
                            ),
                          ),
                        ),
                      MarkdownBody(
                        data: message.message,
                        selectable: true,
                        styleSheet: MarkdownStyleSheet(
                          p: GoogleFonts.outfit(
                            color: AppTheme.textPrimary,
                            fontSize: 14,
                            height: 1.5,
                          ),
                          code: GoogleFonts.firaCode(
                            backgroundColor: Colors.black26,
                            color: Colors.orangeAccent,
                            fontSize: 13,
                          ),
                          codeblockDecoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (message.isUser) _buildUserAvatar(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 52, right: 52),
            child: Text(
              _formatTimestamp(message.timestamp),
              style: GoogleFonts.outfit(
                color: AppTheme.textSecondary.withOpacity(0.5),
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.primaryRed.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.primaryRed.withOpacity(0.3)),
      ),
      child: const Icon(Icons.smart_toy, color: AppTheme.primaryRed, size: 18),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceMedium,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person, color: AppTheme.textSecondary, size: 18),
    );
  }

  String _formatTimestamp(DateTime dt) {
    return "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }
}
