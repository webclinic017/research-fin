import 'package:flutter/material.dart';

import 'package:researchfin/theme/colors.dart';
import 'package:researchfin/theme/text_theme.dart';


ThemeData researchFinTheme = ThemeData(
  accentColor: Colors.white,
  brightness: Brightness.dark,
  // // cursorColor: Colors.white,
  // dialogBackgroundColor: AppColor.overlayFive,
  // hintColor: Colors.white60,
  // iconTheme: IconThemeData(
  //   color: Colors.white,
  // ),
  // bottomSheetTheme: BottomSheetThemeData(
  //   modalBackgroundColor: AppColor.darkGrey,
  //   shape: RoundedRectangleBorder(
  //     borderRadius: BorderRadius.only(
  //       topLeft: Radius.circular(10.0),
  //       topRight: Radius.circular(10.0),
  //     ),
  //   ),
  // ),
  // dialogTheme: DialogTheme().copyWith(
  //   contentTextStyle: sigmaTextTheme.subtitle2,
  // ),
  primaryColor: AppColor.stockBlack,
  scaffoldBackgroundColor: AppColor.stockBlack,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.white,
    selectionColor: Colors.white.withOpacity(0.5),
    selectionHandleColor: Colors.white,
  ),
  textTheme: researchFinTextTheme,
  // textButtonTheme: TextButtonThemeData(
  //   style: ButtonStyle(
  //     backgroundColor: MaterialStateProperty.all<Color>(AppColor.overlayFourteen),
  //     foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  //     overlayColor: MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.2)),
  //     textStyle: MaterialStateProperty.all<TextStyle>(
  //       TextStyle(
  //         fontFamily: 'Montserrat',
  //       ),
  //     ),
  //   ),
  // ),
);
