import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freedom_chat/common/widgets/loading_overlay.dart';
import 'package:freedom_chat/modules/auth/controller/auth_controller.dart';

import '../../../common/constants/colors.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const String routeName = '/login';
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool rememberMe = false;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void sendOtp() {
    ref
        .read(authControllerProvider.notifier)
        .sendOtp(context, phoneController.text);
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      body: LoadingOverlay(
        isLoading: isLoading,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Image.asset(
                    MediaQuery.of(context).platformBrightness ==
                            Brightness.light
                        ? "assets/images/Logo_light.png"
                        : "assets/images/Logo_dark.png",
                    height: 146,
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Log In',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Let’s get your freedom account back on track.',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      label: Text('Mobile Number'),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                      hintText: 'Enter Mobile Number',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(
                        height: 24.0,
                        width: 24.0,
                        child: Checkbox(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          fillColor:
                              MaterialStateProperty.all<Color?>(kPrimaryColor),
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          value: rememberMe,
                          onChanged: (value) =>
                              setState(() => rememberMe = value!),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text(
                        'Remember me',
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  PrimaryButton(text: "Sign In", press: () => sendOtp()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    required this.text,
    required this.press,
    this.color = kPrimaryColor,
    this.padding = const EdgeInsets.all(kDefaultPadding * 0.75),
  }) : super(key: key);

  final String text;
  final VoidCallback press;
  final Color color;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      padding: padding,
      color: color,
      minWidth: double.infinity,
      onPressed: press,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
