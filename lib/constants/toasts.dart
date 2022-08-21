import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:opencv_canny_test/constants/colors.dart';

void dataAddedToDatabase() {
  Fluttertoast.showToast(
      msg: "Data Added To Firestore",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      backgroundColor: PlotlineColors.kMenuBarColor,
      fontSize: 16.0);
}