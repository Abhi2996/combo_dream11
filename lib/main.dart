import 'package:combo_dream11/src/AppPermissions.dart';
import 'package:combo_dream11/src/test_screen/TestScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // permissionToImport();
  AppPermissions().permissionToImport();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cricket Player Management',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TestScreen(),
    );
  }
}
