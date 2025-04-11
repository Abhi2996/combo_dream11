import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermissions {
  // Private constructor to prevent direct instantiation.
  AppPermissions._internal();

  // Static instance variable (singleton instance).
  static final AppPermissions _instance = AppPermissions._internal();

  // Factory constructor to return the singleton instance.
  factory AppPermissions() {
    return _instance;
  }

  // Request storage permission
  Future<void> permissionToImport() async {
    // Check for both Storage and ManageExternalStorage, use whichever is granted.
    if (await Permission.storage.request().isGranted ||
        await Permission.manageExternalStorage.request().isGranted) {
      // Determine the external storage directory.
      final directory = await getExternalStorageDirectory();

      if (directory != null) {
        print(
            'Directory: ${directory.path}'); // Print the actual path for debugging.
      } else {
        print('Unable to access external storage directory.');
      }
    } else {
      print('Permission denied to access storage.');
      // Handle the case where permission is denied.  You might want to:
      // 1.  Show a message to the user explaining why the permission is needed.
      // 2.  Navigate them to the app settings so they can manually grant the permission.
    }
  }
}
