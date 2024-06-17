import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AppConstants{
  static Future<String> getDbPath() async {
    late Directory path;
    if (Platform.isIOS) {
      path = await getLibraryDirectory();
    } else {
      path = await getApplicationDocumentsDirectory();
    }

    return '${path.path}/tb_str';
  }
}