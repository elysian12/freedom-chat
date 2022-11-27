import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freedom_chat/models/message_model.dart';

import '../repository/message_repository.dart';

final getMessagesProvider = StreamProvider.family<List<ChatMessage>, String>(
    (ref, String recieverUserId) {
  final messageRepository = ref.watch(messageRepositoryProvider);
  return messageRepository.getMessages(recieverUserId);
});

final messageControllerProvider = Provider<MessageController>((ref) {
  final messageRepository = ref.watch(messageRepositoryProvider);
  return MessageController(messageRepository: messageRepository);
});

class MessageController {
  final MessageRepository _messageRepository;

  MessageController({required MessageRepository messageRepository})
      : _messageRepository = messageRepository;

  void sendMessage(ChatMessage message, String recieverUserId) {
    _messageRepository.sendMessage(message, recieverUserId);
  }
}
