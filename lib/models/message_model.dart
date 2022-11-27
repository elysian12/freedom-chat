// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

enum ChatMessageType { text, audio, image, video }

enum MessageStatus { notSent, notViewed, viewed }

class ChatMessage {
  final String text;
  final String id;
  final ChatMessageType messageType;
  final MessageStatus messageStatus;
  final bool isSender;
  final String uid;
  final DateTime createdAt;

  ChatMessage(
      {this.text = '',
      this.id = '',
      this.uid = '',
      required this.messageType,
      required this.messageStatus,
      required this.isSender,
      required this.createdAt});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'id': id,
      'messageType': messageType.name,
      'messageStatus': messageStatus.name,
      'isSender': isSender,
      'uid': uid,
      'createdAt': createdAt.toString(),
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      text: map['text'] as String,
      id: map['id'] as String,
      messageType: ChatMessageType.values.byName(map['messageType']),
      messageStatus: MessageStatus.values.byName(map['messageStatus']),
      isSender: map['isSender'] as bool,
      uid: map['uid'] as String,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  ChatMessage copyWith({
    String? text,
    String? id,
    ChatMessageType? messageType,
    MessageStatus? messageStatus,
    bool? isSender,
    String? uid,
    DateTime? createdAt,
  }) {
    return ChatMessage(
        text: text ?? this.text,
        id: id ?? this.id,
        messageType: messageType ?? this.messageType,
        messageStatus: messageStatus ?? this.messageStatus,
        isSender: isSender ?? this.isSender,
        uid: uid ?? this.uid,
        createdAt: createdAt ?? this.createdAt);
  }
}

// List demeChatMessages = [
//   ChatMessage(
//     text: "Hi Sajol,",
//     messageType: ChatMessageType.text,
//     messageStatus: MessageStatus.viewed,
//     isSender: false,
//   ),
//   ChatMessage(
//     text: "Hello, How are you?",
//     messageType: ChatMessageType.text,
//     messageStatus: MessageStatus.viewed,
//     isSender: true,
//   ),
//   ChatMessage(
//     text: "",
//     messageType: ChatMessageType.audio,
//     messageStatus: MessageStatus.viewed,
//     isSender: false,
//   ),
//   ChatMessage(
//     text: "",
//     messageType: ChatMessageType.video,
//     messageStatus: MessageStatus.viewed,
//     isSender: true,
//   ),
//   ChatMessage(
//     text: "Error happend",
//     messageType: ChatMessageType.text,
//     messageStatus: MessageStatus.notSent,
//     isSender: true,
//   ),
//   ChatMessage(
//     text: "This looks great man!!",
//     messageType: ChatMessageType.text,
//     messageStatus: MessageStatus.viewed,
//     isSender: false,
//   ),
//   ChatMessage(
//     text: "Glad you like it",
//     messageType: ChatMessageType.text,
//     messageStatus: MessageStatus.notViewed,
//     isSender: true,
//   ),
// ];
