import 'package:flutter/material.dart';
import '../../../../../Core/resources/color_manager.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.type,
    this.isVisible,
    this.validator,
    this.suffixIcon,
    this.controller,
  });

  final TextInputType? type;
  final bool? isVisible;
  final Widget? suffixIcon;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        fillColor: ColorManager.darkGrey,
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 4),
          child: suffixIcon,
        ),
        border: buildBorder(),
        enabledBorder: buildBorder(),
        focusedBorder: buildBorder(),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
      ),
      controller: controller,
      obscureText: isVisible ?? false,
      validator: validator,
      keyboardType: type,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textAlignVertical: TextAlignVertical.center,
      style: TextStyle(
        color: ColorManager.white,
      ),
    );
  }

  OutlineInputBorder buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide(
        color: ColorManager.darkGrey,
      ),
    );
  }
}
