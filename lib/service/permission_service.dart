import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<void> requestMicPermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }
}
