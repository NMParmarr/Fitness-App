import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_fitness/common/color_extension.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController ctr;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obsecuredText;
  final TextInputType? inputType;
  final String? hintText;
  final String? labelText;
  final int? lines;
  final bool? readOnly;
  final int? maxLength;
  final TextCapitalization? capitalization;
  final bool tapOutsideDismiss;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry? contentPadding;
  final Function(String)? onChanged;


  const CustomTextField({
    required this.ctr,
    this.suffixIcon,
    this.prefixIcon,
    this.obsecuredText = false,
    this.inputType,
    this.labelText,
    this.hintText,
    this.lines,
    this.readOnly,
    this.contentPadding,
    this.maxLength,
    this.tapOutsideDismiss = false,
    this.inputFormatters,
    this.capitalization,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: inputFormatters,
      controller: ctr,
      obscureText: obsecuredText,
      keyboardType: inputType,
      maxLength: maxLength,
      readOnly: readOnly ?? false,
      maxLines: lines ?? 1,
      onChanged: onChanged,
      cursorColor: TColor.primary,
      style: TextStyle(
        fontSize: 17,
      ),
      textCapitalization: capitalization ?? TextCapitalization.none,
      onTapOutside: (_) {
        if (tapOutsideDismiss) {
          FocusScope.of(context).unfocus();
        }
      },
      decoration: InputDecoration(
          counterText: "",
          hintStyle: TextStyle(color: Colors.grey),
          labelText: labelText,
          hintText: hintText,
          contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          border: OutlineInputBorder(gapPadding: 0, borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.grey.withOpacity(0.10),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon),
    );
  }
}
