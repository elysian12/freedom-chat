import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freedom_chat/common/constants/theme.dart';
import 'package:freedom_chat/firebase_options.dart';
import 'package:freedom_chat/modules/welcome/welcome_screen.dart';
import 'package:freedom_chat/routes/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
      themeMode: ThemeMode.system,
      onGenerateRoute: MyRouter.generateRoute,
      initialRoute: WelcomeScreen.routeName,
    );
  }
}
