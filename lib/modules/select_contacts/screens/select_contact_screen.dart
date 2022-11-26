import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freedom_chat/common/widgets/loading_overlay.dart';
import 'package:freedom_chat/modules/select_contacts/controller/select_contact_controller.dart';

class SelectContactScreen extends ConsumerWidget {
  static const String routeName = '/contact-screen';
  const SelectContactScreen({super.key});

  void selectContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref
        .read(selectContactControllerProvider)
        .selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select contact'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
            data: (contactList) {
              return ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  final contact = contactList[index];
                  return ListTile(
                    onTap: () => selectContact(ref, contact, context),
                    title: Text(
                      contact.displayName,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    leading: contact.photo == null
                        ? null
                        : CircleAvatar(
                            backgroundImage: MemoryImage(contact.photo!),
                            radius: 30,
                          ),
                  );
                },
              );
            },
            error: (error, stackTrace) =>
                ErrorText(errorText: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
