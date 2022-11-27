import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freedom_chat/models/chat_contacts.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(
      firebaseAuth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance);
});

class ChatRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  ChatRepository(
      {required FirebaseFirestore firestore,
      required FirebaseAuth firebaseAuth})
      : _firestore = firestore,
        _firebaseAuth = firebaseAuth;

  Stream<List<Chat>> getUserChats() {
    return _firestore
        .collection('chats')
        .where('users', arrayContains: _firebaseAuth.currentUser!.uid)
        .snapshots()
        .map((event) {
      List<Chat> chats = [];

      for (var chat in event.docs) {
        chats.add(Chat.fromMap(chat.data()));
      }
      return chats;
    });
  }
}
