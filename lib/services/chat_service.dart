import '../models/message.dart';

class ChatService {
  // Mock implementation
  Stream<List<ChatMessage>> getMessages(String matchId) {
    return Stream.value([]);  // Return empty list for now
  }

  Future<void> sendMessage(String matchId, ChatMessage message) async {
    // Mock implementation
  }
} 