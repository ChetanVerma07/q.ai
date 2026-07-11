import 'package:flutter/material.dart';

class AboutTeamPage extends StatelessWidget {
  const AboutTeamPage({super.key});

  // -------------------------------------------------------------
  // CLAUDE-INSPIRED DARK PALETTE (Hardcoded for Component Isolation)
  // -------------------------------------------------------------
  static const Color _bg = Color(0xFF171411);         // Deep charcoal background
  static const Color _surface = Color(0xFF1E1A16);    // Main card surface
  static const Color _surfaceSoft = Color(0xFF27221D); // Lighter card surface
  static const Color _border = Color(0xFF494139);     // Warm grey borders
  static const Color _accent = Color(0xFFD97757);     // Earthy Rust (Primary focus)
  static const Color _accent2 = Color(0xFFE2B089);    // Soft Sand (Secondary)
  static const Color _textPrimary = Color(0xFFF6F1EA); // Warm cream text
  static const Color _textSecondary = Color(0xFFB7ADA0); // Sand text
  static const Color _success = Color(0xFF73A884);    // Earthy moss green
  static const Color _warning = Color(0xFFD49A57);    // Warm mustard gold

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg, // Sets the entire screen to dark charcoal
      appBar: AppBar(
        title: const Text(
          'ABOUT',
          style: TextStyle(
            color: _textPrimary,
            letterSpacing: 2.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent, // Transparent to blend with bg
        elevation: 0,
        iconTheme: const IconThemeData(color: _textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 32),
            const Text(
              'Founders',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            _buildFounderCard(
              name: 'Chetan Verma',
              role: 'Co-Founder & C.T.O',
              description:
              'Chetan Verma is one of the founders of QuantSpace.ai and plays a major role in the development of the platform. He is focused on building the product vision, user experience, and AI-powered capabilities of QuantSpace.ai.',
              icon: Icons.code_rounded,
              color: _accent, // Rust Orange
            ),
            const SizedBox(height: 16),
            _buildFounderCard(
              name: 'Anubhav Singh Rajput',
              role: 'Co-Founder & C.F.O',
              description:
              'Anubhav Singh Rajput is a founder of QuantSpace.ai and contributes to the platform’s development, planning, and innovation. He works alongside the team to shape QuantSpace.ai into a smart and useful AI platform for users.',
              icon: Icons.lightbulb_rounded,
              color: _success, // Moss Green
            ),
            const SizedBox(height: 16),
            _buildFounderCard(
              name: 'Kanishk Verma',
              role: 'Co-Founder & C.D.O',
              description:
              'Kanishk Verma is also a founder of QuantSpace.ai and is involved in the development journey of the platform. He contributes to team collaboration, execution, and the overall growth of the project.',
              icon: Icons.groups_rounded,
              color: _warning, // Mustard Gold
            ),
            const SizedBox(height: 24),
            _buildFounderCard(
              name: 'Mohnish Gaur',
              role: 'Moderations',
              description:
              'Mohnish Gaur is involved in the development journey of the platform. He contributes to team collaboration, execution, and the overall growth of the project.',
              icon: Icons.security_rounded,
              color: _accent2, // Soft Sand
            ),
            const SizedBox(height: 32),
            _buildVisionCard(),
            const SizedBox(height: 24), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _surfaceSoft,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: _accent,
              size: 28,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'QuantSpace.ai',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'QuantSpace.ai is being developed as an AI-driven platform by Anubhav Singh Rajput, Chetan Verma, and Kanishk Verma. The platform reflects their shared vision of building a modern, intelligent, and impactful technology product.',
            style: TextStyle(
              color: _textSecondary,
              fontSize: 15,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _bg, // Inset look
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: _border),
            ),
            child: const Text(
              'Founded by first-year B.Tech students',
              style: TextStyle(
                color: _accent2,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFounderCard({
    required String name,
    required String role,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Subtle shadow
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Icon(
              icon,
              color: color,
              size: 26,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(
                    color: _textSecondary,
                    fontSize: 14,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _surfaceSoft,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.rocket_launch_rounded, color: _accent),
              SizedBox(width: 12),
              Text(
                'Our Vision',
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'QuantSpace.ai represents the ambition, creativity, and technical dedication of three first-year B.Tech students who want to build an advanced AI platform for the future. Their journey reflects innovation, teamwork, and a strong belief in creating technology that can make a real difference.',
            style: TextStyle(
              color: _textSecondary,
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
