import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void dataAddedToDatabase() {
  Fluttertoast.showToast(
      msg: "Data Added To Firestore",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      backgroundColor: Colors.blue[400],
      fontSize: 16.0);
}