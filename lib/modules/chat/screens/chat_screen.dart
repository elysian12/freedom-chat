import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freedom_chat/common/constants/colors.dart';
import 'package:freedom_chat/common/widgets/loading_overlay.dart';
import 'package:freedom_chat/models/chat_contacts.dart';
import 'package:freedom_chat/models/user_model.dart';
import 'package:freedom_chat/modules/auth/controller/auth_controller.dart';
import 'package:freedom_chat/modules/chat/controller/chat_controller.dart';
import 'package:freedom_chat/modules/chat/widgets/chat_card.dart';
import 'package:freedom_chat/modules/message/screens/message_screen.dart';
import 'package:freedom_chat/modules/select_contacts/screens/select_contact_screen.dart';

class ChatScreen extends ConsumerStatefulWidget {
  static const String routeName = '/chat-screen';
  const ChatScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Chats"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: ref.watch(getChatsProvider).when(
            data: (chats) {
              return ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) => ChatCard(
                  chat: chats[index],
                  press: () {
                    var receiverUid = chats[index].users[0] !=
                            FirebaseAuth.instance.currentUser!.uid
                        ? chats[index].users[0]
                        : chats[index].users[1];
                    log(receiverUid);
                    Navigator.pushNamed(
                      context,
                      MessageScreen.routeName,
                      arguments: {
                        'name': chats[index].userInfo[receiverUid],
                        'uid': receiverUid,
                      },
                    );
                  },
                ),
              );
            },
            error: (error, stackTrace) =>
                ErrorText(errorText: error.toString()),
            loading: () => const Loader(),
          ),
      bottomNavigationBar: buildBottomNavigationBar(user),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () =>
            Navigator.pushNamed(context, SelectContactScreen.routeName),
        child: const Icon(
          Icons.people,
          color: kContentColorDarkTheme,
        ),
      ),
    );
  }

  BottomNavigationBar buildBottomNavigationBar(UserModel user) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (value) {
        setState(() {
          _selectedIndex = value;
        });
      },
      items: [
        const BottomNavigationBarItem(
            icon: Icon(Icons.messenger), label: "Chats"),
        const BottomNavigationBarItem(icon: Icon(Icons.call), label: "Calls"),
        BottomNavigationBarItem(
          icon: CircleAvatar(
            radius: 14,
            backgroundImage: NetworkImage(user.profilePic),
          ),
          label: "Profile",
        ),
      ],
    );
  }
}
