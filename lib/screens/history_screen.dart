// lib/screens/history_screen.dart
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../widgets/loading_skeleton.dart';
import 'home_screen.dart';
import 'chat_screen.dart';
import 'settings_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _isLoading = true;

  final List<ChatHistoryItem> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _history.addAll([
        ChatHistoryItem(
          id: '1',
          title: 'Explain Quantum Computing',
          date: 'Mar 6, 2026 14:23',
          preview: 'Quantum computing uses qubits...',
          icon: Icons.science,
          model: 'Grok 4.1',
          folder: 'Research 🔬',
        ),
        ChatHistoryItem(
          id: '2',
          title: 'Flutter Riverpod Tutorial',
          date: 'Mar 6, 2026 13:45',
          preview: 'Riverpod is a state management...',
          icon: Icons.code,
          model: 'GPT-4o',
          folder: 'Technology 💻',
        ),
        ChatHistoryItem(
          id: '3',
          title: 'Best AI Tools 2026',
          date: 'Mar 6, 2026 12:30',
          preview: 'Top AI tools for developers...',
          icon: Icons.trending_up,
          model: 'Claude 3.5',
          folder: 'Technology 💻',
        ),
        ChatHistoryItem(
          id: '4',
          title: 'React vs Flutter',
          date: 'Mar 6, 2026 11:15',
          preview: 'Comparison of React Native vs Flutter...',
          icon: Icons.compare_arrows,
          model: 'Gemini 2.0',
          folder: 'Coding 🐛',
        ),
        ChatHistoryItem(
          id: '5',
          title: 'Python DSA Practice',
          date: 'Mar 6, 2026 10:20',
          preview: 'Data structures and algorithms...',
          icon: Icons.calculate,
          model: 'Llama 3.1',
          folder: 'Academics 📖',
        ),
      ]);
      _isLoading = false;
    });
  }

  void _navigateToChat(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ChatScreen()),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Chat History',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFFE57373)),
            onPressed: _isLoading ? null : () => _showSearchDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.chat, color: Color(0xFFE57373)),
            onPressed: () => _navigateToChat(context),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Color(0xFFE57373)),
            color: const Color(0xFF1A1A1A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'clear_all', child: Text('Clear All')),
              PopupMenuItem(value: 'export', child: Text('Export History')),
              PopupMenuItem(value: 'settings', child: Text('Settings')),
            ],
            onSelected: (value) {
              if (_isLoading) return;
              if (value == 'clear_all') _clearAllHistory();
              if (value == 'export') _exportHistory();
              if (value == 'settings') _navigateToSettings(context);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const HistoryLoadingSkeleton()
          : Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE57373).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_history.length}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'Total Chats',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _navigateToChat(context),
                  icon: const Icon(Icons.add, size: 18, color: Colors.white),
                  label: const Text(
                    'New Chat',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE57373),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _history.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _history.length,
              itemBuilder: (context, index) =>
                  _buildHistoryItem(_history[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(ChatHistoryItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _openChat(item.id),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE57373).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(item.icon, color: const Color(0xFFE57373), size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item.model,
                              style: const TextStyle(
                                color: Color(0xFFE57373),
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.folder,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.preview,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      item.date,
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    const Icon(
                      Icons.chevron_right,
                      color: Color(0xFFE57373),
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
              color: Color(0xFF1A1A1A),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.history, color: Color(0xFFE57373), size: 64),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Chat History',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Start chatting with Q.Ai to see your history here',
            style: TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _navigateToChat(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE57373),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            icon: const Icon(Icons.chat),
            label: const Text('Start New Chat'),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showSearch(
      context: context,
      delegate: HistorySearchDelegate(_history),
    );
  }

  void _clearAllHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Clear History?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'All chat history will be permanently deleted.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _history.clear());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('History cleared!'),
                  backgroundColor: Color(0xFFE57373),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE57373),
            ),
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _exportHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export feature coming soon!'),
        backgroundColor: Color(0xFFE57373),
      ),
    );
  }

  void _openChat(String chatId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening chat $chatId...'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'Go to Chat',
          textColor: Colors.white,
          onPressed: () => _navigateToChat(context),
        ),
      ),
    );
  }
}

class HistorySearchDelegate extends SearchDelegate<ChatHistoryItem?> {
  final List<ChatHistoryItem> _history;

  HistorySearchDelegate(this._history);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0A0A0A),
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white54),
        border: InputBorder.none,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Color(0xFFE57373)),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = _history
        .where((item) => item.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Container(
      color: const Color(0xFF0A0A0A),
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) => ListTile(
          leading: Icon(results[index].icon, color: const Color(0xFFE57373)),
          title: Text(
            results[index].title,
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            results[index].preview,
            style: const TextStyle(color: Colors.white70),
          ),
          trailing: Text(
            results[index].date,
            style: const TextStyle(color: Colors.grey),
          ),
          onTap: () => close(context, results[index]),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = _history
        .where((item) => item.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Container(
      color: const Color(0xFF0A0A0A),
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) => ListTile(
          leading: Icon(suggestions[index].icon, color: const Color(0xFFE57373)),
          title: Text(
            suggestions[index].title,
            style: const TextStyle(color: Colors.white),
          ),
          onTap: () {
            query = suggestions[index].title;
            showResults(context);
          },
        ),
      ),
    );
  }
}

class ChatHistoryItem {
  final String id;
  final String title;
  final String date;
  final String preview;
  final IconData icon;
  final String model;
  final String folder;

  ChatHistoryItem({
    required this.id,
    required this.title,
    required this.date,
    required this.preview,
    required this.icon,
    required this.model,
    required this.folder,
  });
}