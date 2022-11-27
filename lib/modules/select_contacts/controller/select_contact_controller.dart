import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/select_contact_repository.dart';

final getContactsProvider = FutureProvider((ref) {
  final selectContactRepository = ref.watch(selectContactsRepositoryProvider);
  return selectContactRepository.getContacts();
});

final selectContactControllerProvider =
    StateNotifierProvider<SelectContactNotifier, bool>((ref) {
  final selectContactRepository = ref.watch(selectContactsRepositoryProvider);
  return SelectContactNotifier(contactRepository: selectContactRepository);
});

class SelectContactNotifier extends StateNotifier<bool> {
  final SelectContactRepository _contactRepository;
  SelectContactNotifier({required SelectContactRepository contactRepository})
      : _contactRepository = contactRepository,
        super(false);

  void selectContact(Contact selectedContact, BuildContext context) async {
    state = true;
    await _contactRepository.selectContact(selectedContact, context);
    state = false;
  }
}
