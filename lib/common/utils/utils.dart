import 'package:flutter/material.dart';
import 'package:freedom_chat/common/constants/colors.dart';

void showLoadingDialog(BuildContext context) async {
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

void showSnackBar(BuildContext context, String text,
    {Color backroundColor = kPrimaryColor}) async {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        backgroundColor: backroundColor,
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      ),
    );
}
