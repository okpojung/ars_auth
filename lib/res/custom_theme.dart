import 'package:flutter/material.dart';
import 'custom_colors.dart';
import 'constants.dart';

// 커스텀 테마 시스템
class CustomTheme {
  // 텍스트 스타일
  static const TextStyle buttonText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle titleText = TextStyle(
    fontFamily: AppConstants.fontLeferi,
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    color: CustomColors.textPrimary,
  );

  static const TextStyle bodyText = TextStyle(
    fontFamily: AppConstants.fontSCDream,
    fontSize: 14.0,
    fontWeight: FontWeight.w300,
    color: CustomColors.textSecondary,
  );

  static const TextStyle optionText = TextStyle(
    fontFamily: AppConstants.fontLeferi,
    fontSize: 11.0,
    fontWeight: FontWeight.w300,
    color: CustomColors.textError,
  );

  // 다이얼로그 테마
  static const DialogTheme dialogTheme = DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(20),
        bottomLeft: Radius.circular(20),
      ),
    ),
    backgroundColor: CustomColors.surface,
    titleTextStyle: titleText,
    contentTextStyle: bodyText,
  );
}
