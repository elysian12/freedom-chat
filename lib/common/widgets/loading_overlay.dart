// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  const LoadingOverlay({
    Key? key,
    required this.isLoading,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        isLoading ? const Loader() : const SizedBox.shrink(),
      ],
    );
  }
}

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kContentColorLightTheme.withOpacity(0.5),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ErrorText extends StatelessWidget {
  final String errorText;
  const ErrorText({Key? key, required this.errorText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(errorText),
    );
  }
}
