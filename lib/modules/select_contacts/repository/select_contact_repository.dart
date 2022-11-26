import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freedom_chat/common/utils/utils.dart';
import 'package:freedom_chat/models/user_model.dart';
import 'package:freedom_chat/modules/message/screens/message_screen.dart';

final selectContactsRepositoryProvider = Provider(
  (ref) => SelectContactRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class SelectContactRepository {
  final FirebaseFirestore _firestore;

  SelectContactRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

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

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      var userCollection = await _firestore.collection('users').get();
      bool isFound = false;

      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectedPhoneNum = selectedContact.phones[0].number.replaceAll(
          ' ',
          '',
        );
        if (selectedPhoneNum == userData.phoneNumber) {
          isFound = true;
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
}
