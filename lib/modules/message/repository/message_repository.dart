import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freedom_chat/common/utils/type_defs.dart';
import 'package:freedom_chat/models/message_model.dart';

final messageRepositoryProvider = Provider<MessageRepository>((ref) {
  return MessageRepository(
      firebaseAuth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance);
});

class MessageRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  MessageRepository(
      {required FirebaseFirestore firestore,
      required FirebaseAuth firebaseAuth})
      : _firestore = firestore,
        _firebaseAuth = firebaseAuth;

  Stream<List<ChatMessage>> getMessages(String recieverUserId) {
    String chatId = chatRoomId(recieverUserId, _firebaseAuth.currentUser!.uid);
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) {
      List<ChatMessage> messages = [];

      for (var message in event.docs) {
        var msg = ChatMessage.fromMap(message.data());
        if (msg.uid == _firebaseAuth.currentUser!.uid) {
          msg = msg.copyWith(isSender: true);
        } else {
          msg = msg.copyWith(isSender: false);
        }
        messages.add(msg);
      }

      return messages;
    });
  }

  Future<void> sendMessage(ChatMessage message, String recieverUserId) async {
    log('from repository(from ui)  $recieverUserId');
    String chatId = chatRoomId(
      _firebaseAuth.currentUser!.uid,
      recieverUserId,
    );

    log('chat Id : $chatId');
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(message.id)
        .set(
          message.toMap(),
        );
    await _firestore.collection('chats').doc(chatId).update(
      {
        'lastMessage': message.text,
      },
    );
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2[0].toLowerCase().codeUnits[0]) {
      return '$user1$user2';
    } else {
      return '$user2$user1';
    }
  }
}
