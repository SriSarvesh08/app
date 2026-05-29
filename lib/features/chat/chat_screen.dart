import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../config/theme/app_colors.dart';
import '../../core/services/ai_service.dart';
import '../../core/services/tts_service.dart';
import '../../core/database/database_helper.dart';
import '../../models/chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  
  // Voice Input Variables
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _autoSpeak = false; // "Hands-Free Auto-Voice" mode toggle

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _loadHistory();
  }

  void _toggleListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val == 'done' || val == 'notListening') {
            setState(() => _isListening = false);
          }
        },
        onError: (val) => debugPrint('Speech Error: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _controller.text = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> _loadHistory() async {
    final db = DatabaseHelper.instance;
    final rows = await db.queryAll('chat_messages');
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name') ?? 'Friend';
    final group = prefs.getString('user_group') ?? 'TNPSC Exams';

    if (mounted) {
      setState(() {
        _messages.addAll(rows.map((r) => ChatMessage.fromMap(r)));
      });
      if (_messages.isEmpty) {
        _addWelcomeMessage(name, group);
      }
    }
  }

  void _addWelcomeMessage(String name, String group) {
    final welcome = ChatMessage(
      message: "Hello $name! 👋 I'm your **TNPSC AI Assistant**.\n\n"
          "I see you are preparing for **$group**. I can help you with:\n"
          "📊 Aptitude & Shortcuts\n"
          "🧩 Reasoning & Puzzles\n"
          "📝 English & Grammar\n"
          "📰 Current Affairs\n"
          "🎯 TNPSC Strategy\n\n"
          "Ask me anything to get started!",
      isUser: false,
    );
    setState(() => _messages.add(welcome));
    _saveMessage(welcome);
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    _controller.clear();

    final userMsg = ChatMessage(message: text, isUser: true);
    setState(() {
      _messages.add(userMsg);
      _isTyping = true;
    });
    _saveMessage(userMsg);
    _scrollToBottom();

    final response = await AIService.instance.generateResponse(text);
    final aiMsg = ChatMessage(message: response, isUser: false);

    if (mounted) {
      setState(() {
        _messages.add(aiMsg);
        _isTyping = false;
      });
      _saveMessage(aiMsg);
      _scrollToBottom();
      
      // Hands-free voice feedback: auto-speak the generated response!
      if (_autoSpeak) {
        TTSService.instance.speak(response);
      }
    }
  }

  Future<void> _saveMessage(ChatMessage msg) async {
    await DatabaseHelper.instance.insert('chat_messages', msg.toMap());
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Assistant', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.textPrimary)),
                Text(
                  _isTyping ? 'Typing...' : 'Online • Offline Ready',
                  style: TextStyle(fontSize: 11, color: _isTyping ? AppColors.success : (isDark ? Colors.white38 : AppColors.textSecondary)),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _autoSpeak ? Icons.headset_rounded : Icons.headset_off_rounded,
              color: _autoSpeak ? AppColors.success : null,
            ),
            tooltip: 'Toggle Hands-Free Auto-Voice',
            onPressed: () {
              setState(() => _autoSpeak = !_autoSpeak);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_autoSpeak ? 'Hands-Free Voice On' : 'Hands-Free Voice Off'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () => _showClearDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Suggestion chips
          if (_messages.length <= 1)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _suggestionChip('📊 Percentage shortcuts', isDark),
                  _suggestionChip('🎯 TNPSC tips', isDark),
                  _suggestionChip('📅 Study plan', isDark),
                  _suggestionChip('⚡ Quick tricks', isDark),
                ],
              ),
            ),
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator(isDark);
                }
                return _buildBubble(_messages[index], isDark);
              },
            ),
          ),
          // Input
          _buildInput(isDark),
        ],
      ),
    );
  }

  Widget _suggestionChip(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(text, style: const TextStyle(fontSize: 12)),
        backgroundColor: isDark ? AppColors.darkCard : Colors.white,
        side: BorderSide(color: isDark ? AppColors.darkBorder : Colors.grey.shade200),
        onPressed: () => _sendMessage(text.substring(2).trim()),
      ),
    );
  }

  Widget _buildBubble(ChatMessage msg, bool isDark) {
    final isUser = msg.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 4, bottom: 4,
          left: isUser ? 60 : 0,
          right: isUser ? 0 : 60,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isUser ? AppColors.primaryGradient : null,
          color: isUser ? null : (isDark ? AppColors.darkCard : const Color(0xFFF0F2F5)),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 18),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRichText(msg.message, isUser, isDark),
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${msg.createdAt.hour.toString().padLeft(2, '0')}:${msg.createdAt.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 10,
                    color: isUser ? Colors.white54 : (isDark ? Colors.white30 : Colors.grey),
                  ),
                ),
                if (!isUser) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => TTSService.instance.speak(msg.message),
                    child: Icon(Icons.volume_up_rounded, size: 14,
                      color: isDark ? Colors.white30 : Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: msg.message));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied!'), duration: Duration(seconds: 1)),
                      );
                    },
                    child: Icon(Icons.copy_rounded, size: 14,
                      color: isDark ? Colors.white30 : Colors.grey),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRichText(String text, bool isUser, bool isDark) {
    // Simple markdown-like bold rendering
    final spans = <TextSpan>[];
    final parts = text.split('**');
    for (int i = 0; i < parts.length; i++) {
      spans.add(TextSpan(
        text: parts[i],
        style: TextStyle(
          fontWeight: i % 2 == 1 ? FontWeight.w700 : FontWeight.w400,
          color: isUser ? Colors.white : (isDark ? Colors.white.withOpacity(0.87) : AppColors.textPrimary),
          fontSize: 14,
          height: 1.5,
        ),
      ));
    }
    return RichText(text: TextSpan(children: spans));
  }

  Widget _buildTypingIndicator(bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 4, bottom: 4, right: 100),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : const Color(0xFFF0F2F5),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
            bottomLeft: Radius.circular(4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 600 + (i * 200)),
              builder: (context, value, child) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 8, height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.3 + (value * 0.4)),
                    shape: BoxShape.circle,
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _buildInput(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: isDark ? AppColors.darkBorder : Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        maxLines: 4,
                        minLines: 1,
                        textInputAction: TextInputAction.send,
                        onSubmitted: _sendMessage,
                        decoration: const InputDecoration(
                          hintText: 'Ask me anything...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                        color: _isListening ? AppColors.error : (isDark ? Colors.white54 : Colors.grey),
                      ),
                      onPressed: _toggleListening,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _sendMessage(_controller.text),
              child: Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: AppColors.primaryBlue.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Chat'),
        content: const Text('Delete all chat messages?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await DatabaseHelper.instance.delete('chat_messages', '1=1', []);
              setState(() => _messages.clear());
              final prefs = await SharedPreferences.getInstance();
              final name = prefs.getString('user_name') ?? 'Friend';
              final group = prefs.getString('user_group') ?? 'TNPSC Exams';
              _addWelcomeMessage(name, group);
              if (mounted) Navigator.pop(ctx);
            },
            child: const Text('Clear', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
