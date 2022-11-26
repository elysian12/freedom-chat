import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freedom_chat/common/services/shared_service.dart';
import 'package:freedom_chat/modules/auth/screens/login_screen.dart';
import 'package:freedom_chat/modules/chat/screens/chat_screen.dart';

import '../../models/user_model.dart';
import '../auth/controller/auth_controller.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  static const String routeName = '/welcome';
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  UserModel? userModel;

  Future<void> getData(WidgetRef ref) async {
    var uid = await ref.read(sharedServiceProvider).getSharedUUID();
    if (uid != null) {
      userModel = await ref
          .watch(authControllerProvider.notifier)
          .getUserDat(uid)
          .first;
      ref.read(userProvider.notifier).updateUser(userModel);
    }
  }

  void navigateTo() async {
    if (mounted) {
      await getData(ref);
      if (userModel == null) {
        await Future.delayed(const Duration(seconds: 2));
        // ignore: use_build_context_synchronously
        Navigator.pushNamedAndRemoveUntil(
            context, LoginScreen.routeName, (route) => false);
      } else {
        log(userModel!.toMap().toString());
        // ignore: use_build_context_synchronously
        Navigator.pushNamedAndRemoveUntil(
            context, ChatScreen.routeName, (route) => false);
      }
    }
  }

  @override
  void initState() {
    navigateTo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            Image.asset("assets/images/welcome_image.png"),
            const Spacer(flex: 3),
            Text(
              "Welcome to our freedom \nmessaging app",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Text(
              "Freedom talk any person of your \nmother language.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .color!
                    .withOpacity(0.64),
              ),
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
