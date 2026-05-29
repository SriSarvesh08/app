class ChatMessage {
  final int? id;
  final String message;
  final bool isUser;
  final DateTime createdAt;

  ChatMessage({
    this.id,
    required this.message,
    required this.isUser,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] as int?,
      message: map['message'] as String,
      isUser: (map['is_user'] as int) == 1,
      createdAt: DateTime.tryParse(map['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'is_user': isUser ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
