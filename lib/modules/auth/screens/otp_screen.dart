import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freedom_chat/common/widgets/loading_overlay.dart';
import 'package:freedom_chat/modules/auth/widgets/pin_input.dart';

import '../../../common/constants/colors.dart';
import '../controller/auth_controller.dart';

class OtpScreen extends ConsumerStatefulWidget {
  static const String routeName = '/otp-screen';
  const OtpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  late TextEditingController pinController;

  @override
  void initState() {
    super.initState();
    pinController = TextEditingController();
  }

  void verifyOtp() {
    ref
        .read(authControllerProvider.notifier)
        .verifyOtp(context, pinController.text);
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
                    'Verify OTP',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Please enter the OTP sent on xxxxx xxx98',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 30),
                  PinInputs(controller: pinController),
                  const SizedBox(height: 30),
                  PrimaryButton(
                    text: "Verify",
                    press: () => verifyOtp(),
                  ),
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
