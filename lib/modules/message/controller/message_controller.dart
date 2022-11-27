import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freedom_chat/common/utils/utils.dart';
import 'package:freedom_chat/models/message_model.dart';
import 'package:uuid/uuid.dart';

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

  void pickFile(BuildContext context, String recieverUserId,
      {bool isVideo = false}) async {
    var response = await _messageRepository.pickFile(isVideo: isVideo);
    response.fold((l) => showSnackBar(context, l.error), (file) async {
      var uploadReponse = await _messageRepository.uploadImageOrVideo(file);
      uploadReponse.fold((l) => showSnackBar(context, l.error), (r) {
        sendMessage(
          ChatMessage(
            messageType:
                isVideo ? ChatMessageType.video : ChatMessageType.image,
            messageStatus: MessageStatus.notViewed,
            isSender: false,
            createdAt: DateTime.now(),
            id: const Uuid().v1(),
            text: r!,
            uid: FirebaseAuth.instance.currentUser!.uid,
          ),
          recieverUserId,
        );
      });
    });
  }
}
