import 'package:flutter/material.dart';
import 'package:opencv_canny_test/constants/colors.dart';

final ThemeData kDarkTheme = ThemeData(
  // colorScheme: ColorScheme.fromSwatch().copyWith(
  //   secondary: PlotlineColors.kBackgroundColor,
  // ),
  //     colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
  //       .copyWith(
  //           secondary: Colors.blueAccent, brightness: Brightness.dark),
  // ),
  primaryColor: PlotlineColors.kBackgroundColor,

  backgroundColor: PlotlineColors.kBackgroundColor,

  brightness: Brightness.dark,

  iconTheme: const IconThemeData(
    color: PlotlineColors.kPrimaryTextColor,
  ),
  // buttonTheme: PlotlineColors.kSecondaryTextColor,
  // textButtonTheme: TextButtonThemeData(
  //   style: TextButton.styleFrom(
  //     textStyle: const TextStyle(
  //         color: PlotlineColors.kSecondaryTextColor,
  //         fontSize: 30,
  //         fontWeight: FontWeight.bold),
  //   ),
  // ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        side: const BorderSide(
            color: PlotlineColors.kSecondaryTextColor, width: 2.5)),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: PlotlineColors.kMenuBarColor,
  ),
);
