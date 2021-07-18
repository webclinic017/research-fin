import 'package:flutter/material.dart';

import 'package:researchfin/theme/colors.dart';
import 'package:researchfin/theme/text_theme.dart';


ThemeData researchFinTheme = ThemeData(
  accentColor: Colors.white,
  brightness: Brightness.dark,
  primaryColor: AppColor.stockBlack,
  scaffoldBackgroundColor: AppColor.stockBlack,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.white,
    selectionColor: Colors.white.withOpacity(0.5),
    selectionHandleColor: Colors.white,
  ),
  textTheme: researchFinTextTheme,
);
