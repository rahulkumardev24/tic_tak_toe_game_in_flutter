import 'package:flutter/cupertino.dart';
import 'package:tic_tak_toe/colors.dart';

/// font Size 24
TextStyle myTextStyle(
    {String fontFamily = "primary",
      Color fontColor = AppColors.textPrimary,
      double fontSize = 21 ,
      FontWeight fontWeight = FontWeight.normal}) {
  return TextStyle(
    color: fontColor,
    fontSize: fontSize,
    fontFamily: fontFamily,
    fontWeight: fontWeight,
  );
}