import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freedom_chat/models/chat_contacts.dart';
import 'package:freedom_chat/modules/chat/repository/chat_repository.dart';

final getChatsProvider = StreamProvider<List<Chat>>((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return chatRepository.getUserChats();
});
