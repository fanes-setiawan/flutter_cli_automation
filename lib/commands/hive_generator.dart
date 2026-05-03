import 'dart:io';

class HiveGenerator {
  static void generate() {
    final dir = Directory('lib/core/storage');
    if (!dir.existsSync()) dir.createSync(recursive: true);

    File('lib/core/storage/local_storage.dart').writeAsStringSync('''
import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage {
  static const String _boxName = 'app_box';
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }
  static Future<void> save(String key, dynamic value) async => await Hive.box(_boxName).put(key, value);
  static dynamic get(String key) => Hive.box(_boxName).get(key);
}
''');
    print('✅ Hive Ready! Panggil \x1B[33mawait LocalStorage.init();\x1B[0m di main.dart Anda.');
  }
}
