import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../../../Core/resources/app_styles.dart';
import '../../../../../Core/resources/color_manager.dart';

class PhoneField extends StatefulWidget {
  const PhoneField({
    super.key,
    required this.phoneController,
    this.onChanged,
  });

  final TextEditingController phoneController;
  final void Function(String)? onChanged;

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      keyboardType: TextInputType.phone,
      controller: widget.phoneController,
      dropdownIcon: Icon(
        Icons.keyboard_arrow_down_sharp,
        color: ColorManager.white,
        size: 27,
      ),
      onCountryChanged: (country) {
        widget.onChanged?.call(widget.phoneController.text);
      },
      dropdownIconPosition: IconPosition.trailing,
      flagsButtonPadding: const EdgeInsets.only(left: 15),
      dropdownTextStyle: AppStyles.styleRegular18(context).copyWith(
        color: ColorManager.white,
      ),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        shape: BoxShape.circle,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: ColorManager.darkGrey,
        contentPadding: const EdgeInsets.symmetric(vertical: 13),
        counterText: '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(
            color: ColorManager.darkGrey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(
            color: ColorManager.darkGrey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(
            color: ColorManager.darkGrey,
          ),
        ),
      ),
      style: TextStyle(
        color: ColorManager.white,
      ),
      initialCountryCode: 'EG',
      onChanged: (value) {
        widget.onChanged?.call(value.completeNumber);
      },
    );
  }
}