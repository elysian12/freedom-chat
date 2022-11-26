import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:freedom_chat/modules/auth/screens/login_screen.dart';
import 'package:freedom_chat/modules/auth/screens/otp_screen.dart';
import 'package:freedom_chat/modules/chat/screens/chat_screen.dart';
import 'package:freedom_chat/modules/message/screens/message_screen.dart';
import 'package:freedom_chat/modules/select_contacts/screens/select_contact_screen.dart';
import 'package:freedom_chat/modules/welcome/welcome_screen.dart';

class MyRouter {
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return const Scaffold(
        body: Center(
          child: Text('Route Not Defined'),
        ),
      );
    });
  }

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    log('Route : ${settings.name}');
    switch (settings.name) {
      case '/':
        return null;

      case WelcomeScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
        );
      case LoginScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case OtpScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const OtpScreen(),
        );
      case ChatScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const ChatScreen(),
        );
      case SelectContactScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const SelectContactScreen(),
        );
      case MessageScreen.routeName:
        final arguments = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => MessageScreen(
            receiverName: arguments['name'],
            receiverUid: arguments['uid'],
          ),
        );

      default:
        return _errorRoute();
    }
  }
}
