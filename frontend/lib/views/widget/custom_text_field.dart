import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/views/utils/color.dart';

class CustomTextField extends StatelessWidget {
  final double width;
  final String hintText;
  final String? label;
  final Key? formKey;
  final FocusNode? focusNode;
  final TextInputType keyBoardType;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final bool? trailingIcon;
  final bool? showIcon;
  final bool? isEnable;
  final bool? wraped;
  final AutovalidateMode autoValidateMode;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onChanged;
  final Widget? suffixIcon;
  final Widget? preffixIcon;
  final bool filled;
  final Color? hintColor;
  final Color? fontColor;
  final int maxLines;
  final Function()? onTap;
  final bool isReadOnly;
  final bool hasHeight;
  final String labelText;
  const CustomTextField({super.key,
    required this.width,
    this.label,
    required this.keyBoardType,
    this.obscureText = false,
    this.validator,
    required this.controller,
    this.textInputAction = TextInputAction.done,
    this.maxLines = 1,
    this.trailingIcon = false,
    this.showIcon = true,
    this.isEnable = true,
    this.wraped,
    this.formKey,
    this.focusNode,
    this.autoValidateMode = AutovalidateMode.onUserInteraction,
    this.fontSize = 17,
    this.padding = const EdgeInsets.symmetric(vertical: 12.0),
    this.inputFormatters,
    this.hintText = "",
    this.onChanged,
    this.suffixIcon,
    this.preffixIcon,
    this.filled = false,
    this.hintColor = AppColors.hintTextColor,
    this.fontColor = AppColors.hintTextColor,
    this.onTap,
    this.isReadOnly = false,
    this.hasHeight = true,
    required this.labelText
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "DMSans")),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        TextFormField(
          readOnly: isReadOnly,
          onTap:onTap,
          key: formKey,
          style: TextStyle(
            color: fontColor,
            fontSize: fontSize,
            fontFamily: 'DMSans',
          ),
          cursorColor: AppColors.primaryColor,
          controller: controller,
          validator: validator,
          autovalidateMode: autoValidateMode,
          enabled: isEnable,
          focusNode: focusNode,
          // maxLines: widget.textInputAction == TextInputAction.newline ? 4 : 1,
          maxLines: maxLines,
          keyboardType: keyBoardType,
          obscureText: obscureText,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hintText,
            filled: filled,
            fillColor: filled ? AppColors.whiteColor : null,

            hintStyle: TextStyle(
              color: hintColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w200,
              fontFamily: 'DMSans',
            ),
            suffixIcon: suffixIcon,
            prefixIcon: preffixIcon,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: filled
                    ? AppColors.whiteColor
                    : AppColors.textFieldBorderColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: filled
                    ? AppColors.whiteColor
                    : AppColors.textFieldBorderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: filled
                    ? AppColors.whiteColor
                    : AppColors.textFieldBorderColor,
              ),
            ),
            labelText: label,
            labelStyle: TextStyle(
              color: hintColor,
              fontSize: fontSize,
              fontFamily: 'DMSans',
            ),
            floatingLabelStyle: TextStyle(
                color: AppColors.primaryColor,
                fontFamily: 'DMSans',
                fontWeight: FontWeight.w600),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.0),
              borderSide: const BorderSide(color: AppColors.errorBackgroundColor),
            ),
          ),
          onChanged: onChanged,
        )
      ],
    );
  }
}


