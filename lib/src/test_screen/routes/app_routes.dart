import 'package:flutter/material.dart';

class NavigationPaths {
  static const String settingsPage = '/SettingsPage';
  //

  static void navigateToScreen(
      {required BuildContext context, required Widget page}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}

//

