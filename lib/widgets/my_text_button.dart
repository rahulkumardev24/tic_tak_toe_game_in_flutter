import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tic_tak_toe/utils/custom_text_style.dart';

import '../colors.dart';

class MyTextButton extends StatelessWidget {
  VoidCallback onTap;
  Color backgroundColor;
  double textSize;
  Color textColor;
  String btnText ;
  FontWeight fontWeight ;
  MyTextButton(
      {super.key,
      this.backgroundColor = AppColors.primary,
      this.textSize = 21,
      this.textColor = AppColors.textPrimary,
        this.fontWeight = FontWeight.normal ,
       required this.btnText ,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      splashColor: Colors.white.withAlpha(20),
      highlightColor: Colors.white.withAlpha(10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: backgroundColor
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: Text(
            "START GAME",
            style: myTextStyle(fontSize: textSize, fontColor: textColor , fontWeight: fontWeight),
          ),
        ),
      ),
    );
  }
}
