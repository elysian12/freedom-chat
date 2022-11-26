import 'package:flutter/material.dart';
import 'package:freedom_chat/common/constants/colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinInputs extends StatelessWidget {
  final TextEditingController controller;
  const PinInputs({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 6,
      onChanged: (value) {},
      validator: (v) {
        if (v.toString().length != 6) {
          return 'Please enter 6 digits';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      pastedTextStyle: Theme.of(context).textTheme.bodyMedium,
      animationType: AnimationType.scale,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 40,
        errorBorderColor: kErrorColor,
        activeFillColor: Colors.white,
        activeColor: kPrimaryColor,
        disabledColor: kContentColorLightTheme,
        borderWidth: 1.5,
        inactiveColor:
            MediaQuery.of(context).platformBrightness == Brightness.light
                ? kContentColorLightTheme
                : kContentColorDarkTheme,
        selectedColor: kPrimaryColor,
      ),
      cursorColor: kContentColorLightTheme,
      animationDuration: const Duration(milliseconds: 300),
      controller: controller,
      keyboardType: TextInputType.number,
    );
  }
}
