import 'package:flutter/material.dart';


class CustomText extends StatelessWidget {
  const CustomText(
    this.text,{
    super.key,
    this.fontSize = 14.0,
    this.color = Colors.black,
    this.weight = FontWeight.w400,
    this.decoration = TextDecoration.none,
    this.textAlign = TextAlign.start,
    this.maxLines = 15,
    this.italics = false,
    this.overflow = TextOverflow.ellipsis,
    this.height = 1.5,
    this.fontFamily = 'DMSans',
    this.letterSpacing,
  });

  final String text;
  final double fontSize;
  final Color color;
  final FontWeight weight;
  final TextDecoration decoration;
  final TextAlign textAlign;
  final int? maxLines;
  final bool italics;
  final TextOverflow? overflow;
  final double height;
  final String fontFamily;
  final double? letterSpacing;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        height: height,
        fontWeight: weight,
        fontSize: fontSize,
        color: color,
        fontStyle: italics ? FontStyle.italic : FontStyle.normal,
        decoration: decoration,
        fontFamily: fontFamily,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
