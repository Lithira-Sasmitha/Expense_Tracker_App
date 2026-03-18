import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const AppText(
    this.text, {
    super.key,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.textAlign,
    this.overflow,
    this.maxLines,
  });

  factory AppText.h1(String text, {Color? color, TextAlign? textAlign}) {
    return AppText(
      text,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: color,
      textAlign: textAlign,
    );
  }

  factory AppText.h2(String text, {Color? color, TextAlign? textAlign}) {
    return AppText(
      text,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: color,
      textAlign: textAlign,
    );
  }

  factory AppText.body(String text, {Color? color, TextAlign? textAlign}) {
    return AppText(
      text,
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: color,
      textAlign: textAlign,
    );
  }

  factory AppText.small(String text, {Color? color, TextAlign? textAlign}) {
    return AppText(
      text,
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: color,
      textAlign: textAlign,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? Theme.of(context).textTheme.bodyMedium?.color,
      ),
    );
  }
}
