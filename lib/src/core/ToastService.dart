import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastService {
  static bool _isEnabled = true; // Controls whether toast is enabled or not

  static void enableToast() {
    _isEnabled = true;
  }

  static void disableToast() {
    _isEnabled = false;
  }

  static void show({
    required String message,
    ToastGravity gravity = ToastGravity.BOTTOM,
    int timeInSecForIosWeb = 1,
    Color? backgroundColor,
    Color? textColor,
    double fontSize = 16.0,
  }) {
    if (_isEnabled) {
      Fluttertoast.showToast(
        msg: message,
        gravity: gravity,
        timeInSecForIosWeb: timeInSecForIosWeb,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: fontSize,
      );
    }
    debugPrint(message);
  }
}

//For only Debug
class ToastserviceDebug {
  // static bool _isEnabled = true; // Controls whether toast is enabled or not
  static bool _isEnabled = false;
  static void enableToast() {
    _isEnabled = true;
  }

  static void disableToast() {
    _isEnabled = false;
  }

  static void show({
    required String message,
    ToastGravity gravity = ToastGravity.TOP,
    int timeInSecForIosWeb = 1,
    Color? backgroundColor,
    Color? textColor = Colors.red,
    double fontSize = 16.0,
  }) {
    if (_isEnabled) {
      Fluttertoast.showToast(
        msg: message,
        gravity: gravity,
        timeInSecForIosWeb: timeInSecForIosWeb,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: fontSize,
      );
    }
    debugPrint(message);
  }
}
