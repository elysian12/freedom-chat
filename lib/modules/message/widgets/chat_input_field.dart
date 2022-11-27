import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freedom_chat/common/constants/colors.dart';
import 'package:freedom_chat/models/message_model.dart';
import 'package:freedom_chat/modules/message/controller/message_controller.dart';
import 'package:uuid/uuid.dart';

class ChatInputField extends ConsumerStatefulWidget {
  final String recieverUserId;
  const ChatInputField({Key? key, required this.recieverUserId})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends ConsumerState<ChatInputField> {
  late TextEditingController controller;

  void sendMessage(WidgetRef ref, ChatMessage message, String recieverUserId) {
    log('sendMessage(from ui)  $recieverUserId');
    ref.read(messageControllerProvider).sendMessage(message, recieverUserId);
  }

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 32,
            color: const Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            const Icon(Icons.mic, color: kPrimaryColor),
            const SizedBox(width: kDefaultPadding),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 0.75,
                ),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.sentiment_satisfied_alt_outlined,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.64),
                    ),
                    const SizedBox(width: kDefaultPadding / 4),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: "Type message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.attach_file,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.64),
                    ),
                    const SizedBox(width: kDefaultPadding / 4),
                    Icon(
                      Icons.camera_alt_outlined,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.64),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                ChatMessage message = ChatMessage(
                    createdAt: DateTime.now(),
                    messageType: ChatMessageType.text,
                    messageStatus: MessageStatus.notViewed,
                    isSender: FirebaseAuth.instance.currentUser!.uid ==
                        widget.recieverUserId,
                    text: controller.text,
                    id: const Uuid().v1(),
                    uid: FirebaseAuth.instance.currentUser!.uid);
                sendMessage(ref, message, widget.recieverUserId);
                controller.clear();
              },
              icon: const Icon(Icons.send),
            )
          ],
        ),
      ),
    );
  }
}
