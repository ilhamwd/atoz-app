import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputText extends StatelessWidget {
  final TextEditingController? controller;
  final String? placeholder;
  final String? Function(String? value)? validator;
  final void Function(String? value)? onChanged;
  final bool obscureText;
  final int maxLines;
  final TextInputType keyboardType;

  const InputText(
      {Key? key,
      this.controller,
      this.placeholder,
      this.validator,
      this.obscureText = false,
      this.maxLines = 1,
      this.keyboardType = TextInputType.text,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      decoration: BoxDecoration(
          border: Border.all(width: 1.5, color: const Color(0xFFCCCCCC)),
          borderRadius: BorderRadius.circular(5)),
      child: TextFormField(
        keyboardType: keyboardType,
        onChanged: onChanged,
        maxLines: maxLines,
        validator: validator,
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          hintText: placeholder,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
