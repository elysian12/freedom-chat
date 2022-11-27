import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freedom_chat/common/utils/type_defs.dart';
import 'package:freedom_chat/models/error_model.dart';
import 'package:freedom_chat/models/message_model.dart';
import 'package:image_picker/image_picker.dart';

final messageRepositoryProvider = Provider<MessageRepository>((ref) {
  return MessageRepository(
      firebaseAuth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
      firebaseStorage: FirebaseStorage.instance);
});

class MessageRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;
  final FirebaseStorage _firebaseStorage;

  MessageRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
    required FirebaseStorage firebaseStorage,
  })  : _firestore = firestore,
        _firebaseStorage = firebaseStorage,
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

  FutureEither<String?> uploadImageOrVideo(File file) async {
    String? imgUrl;
    final int name = DateTime.now().millisecondsSinceEpoch;
    var ext = file.path.split('.').last;
    log('@@ this is extension : $ext');
    try {
      await _firebaseStorage.ref('files/$name.$ext').putFile(file);
      imgUrl = await _firebaseStorage.ref('files/$name.$ext').getDownloadURL();

      return right(imgUrl);
    } on FirebaseException catch (e) {
      return left(ErrorModel(error: e.message!));
    }
  }

  FutureEither<File> pickFile({bool isVideo = false}) async {
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? xFile = isVideo
          ? await picker.pickVideo(source: ImageSource.gallery)
          : await picker.pickImage(source: ImageSource.gallery);

      if (xFile != null) {
        return right(File(xFile.path));
      } else {
        return left(ErrorModel(error: 'Cancelled'));
      }
    } catch (e) {
      return left(ErrorModel(error: e.toString()));
    }
  }
}
