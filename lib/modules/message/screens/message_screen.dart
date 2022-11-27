import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:freedom_chat/common/constants/colors.dart';
import 'package:freedom_chat/common/widgets/loading_overlay.dart';
import 'package:freedom_chat/models/message_model.dart';
import 'package:freedom_chat/modules/message/controller/message_controller.dart';
import 'package:freedom_chat/modules/message/widgets/chat_input_field.dart';

import '../widgets/message.dart';

class MessageScreen extends ConsumerWidget {
  final String receiverUid;
  final String receiverName;
  static const String routeName = '/message-screen';
  const MessageScreen({
    super.key,
    required this.receiverUid,
    required this.receiverName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: buildAppBar(receiverUid, receiverName),
      body: ref.watch(getMessagesProvider(receiverUid)).when(
            data: (data) {
              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
                      child: ListView.builder(
                        reverse: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) =>
                            Message(message: data[index]),
                      ),
                    ),
                  ),
                  ChatInputField(recieverUserId: receiverUid),
                ],
              );
            },
            error: (error, stackTrace) =>
                ErrorText(errorText: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }

  AppBar buildAppBar(String uid, String userName) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const BackButton(),
          const CircleAvatar(
            backgroundImage: AssetImage("assets/images/user_2.png"),
          ),
          const SizedBox(width: kDefaultPadding * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(fontSize: 16),
              ),
              const Text(
                "Active 3m ago",
                style: TextStyle(fontSize: 12),
              )
            ],
          )
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.local_phone),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.videocam),
          onPressed: () {},
        ),
        const SizedBox(width: kDefaultPadding / 2),
      ],
    );
  }
}
