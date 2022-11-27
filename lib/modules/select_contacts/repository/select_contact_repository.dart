import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freedom_chat/common/utils/utils.dart';
import 'package:freedom_chat/models/chat_contacts.dart';
import 'package:freedom_chat/models/user_model.dart';
import 'package:freedom_chat/modules/message/screens/message_screen.dart';
import 'package:intl/intl.dart';

final selectContactsRepositoryProvider = Provider(
  (ref) => SelectContactRepository(
    firestore: FirebaseFirestore.instance,
    firebaseAuth: FirebaseAuth.instance,
  ),
);

class SelectContactRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  SelectContactRepository(
      {required FirebaseFirestore firestore,
      required FirebaseAuth firebaseAuth})
      : _firestore = firestore,
        _firebaseAuth = firebaseAuth;

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      log(e.toString());
    }
    return contacts;
  }

  Future<void> selectContact(
      Contact selectedContact, BuildContext context) async {
    try {
      var userCollection = await _firestore.collection('users').get();
      bool isFound = false;
      UserModel currentUser;

      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        if (userData.uid == _firebaseAuth.currentUser!.uid) {
          currentUser = userData;
        }
        String selectedPhoneNum = selectedContact.phones[0].number.replaceAll(
          ' ',
          '',
        );
        if (selectedPhoneNum == userData.phoneNumber) {
          isFound = true;

          String chatId =
              chatRoomId(userData.uid, _firebaseAuth.currentUser!.uid);

          var chatroom = await _firestore.collection('chats').doc(chatId).get();

          if (chatroom.exists) {
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
            // ignore: use_build_context_synchronously
            Navigator.pushNamed(
              context,
              MessageScreen.routeName,
              arguments: {
                'name': userData.name,
                'uid': userData.uid,
              },
            );
            return;
          } else {
            Chat chat = Chat(
                id: chatId,
                image: userData.profilePic,
                isActive: false,
                lastMessage: '',
                name: userData.name,
                time: DateFormat('hh:mm a').format(DateTime.now()),
                users: [userData.uid, _firebaseAuth.currentUser!.uid],
                userInfo: {});
            await chatroom.reference.set(chat.toMap());
          }
          // ignore: use_build_context_synchronously
          Navigator.pushNamed(
            context,
            MessageScreen.routeName,
            arguments: {
              'name': userData.name,
              'uid': userData.uid,
            },
          );
        }
      }
      if (!isFound) {
        // ignore: use_build_context_synchronously
        showSnackBar(context, 'This number does not exist on this app.');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
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
