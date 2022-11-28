import 'package:flutter/material.dart';
import 'package:freedom_chat/common/constants/colors.dart';
import 'package:freedom_chat/models/message_model.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key? key,
    this.message,
  }) : super(key: key);

  final ChatMessage? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding * 0.75,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(message!.isSender ? 1 : 0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Wrap(
        children: [
          Text(
            message!.text,
            maxLines: 100,
            textAlign: TextAlign.center,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              color: message!.isSender
                  ? Colors.white
                  : Theme.of(context).textTheme.bodyText1!.color,
            ),
          ),
        ],
      ),
    );
  }
}
