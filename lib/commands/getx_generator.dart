import 'dart:io';
import 'package:path/path.dart' as p;
import '../utils/string_utils.dart';

class GetXGenerator {
  static void generate(String name) {
    final snakeName = name.toSnakeCase();
    final pascalName = name.toPascalCase();
    final baseDir = p.join('lib', 'features', snakeName);

    if (Directory(baseDir).existsSync()) {
      print('⚠️ Feature "$snakeName" sudah ada.');
      return;
    }

    // Create folders
    final folders = ['binding', 'controller', 'view'];
    for (var folder in folders) {
      Directory(p.join(baseDir, folder)).createSync(recursive: true);
    }

    // Create files
    _createFiles(baseDir, snakeName, pascalName);

    // Otomatis Daftarkan Rute
    _injectRoutes(snakeName, pascalName);
    _injectMain();

    print('✅ Berhasil membuat GetX Feature: $pascalName');
    print('\n\x1B[33m💡 Tips: main.dart telah di-update otomatis (GetMaterialApp & Routes).\x1B[0m');
  }

  static void _injectMain() {
    final file = File('lib/main.dart');
    if (!file.existsSync()) return;

    String content = file.readAsStringSync();

    // 1. Tambah Imports
    if (!content.contains("import 'package:get/get.dart';")) {
      content = "import 'package:get/get.dart';\n" + content;
    }
    if (!content.contains("import 'core/routes/app_pages.dart';")) {
      content = "import 'core/routes/app_pages.dart';\n" + content;
    }

    // 2. Ubah MaterialApp jadi GetMaterialApp
    content = content.replaceAll('MaterialApp(', 'GetMaterialApp(');

    // 3. Tambah initialRoute & getPages jika belum ada
    if (!content.contains('getPages:')) {
      content = content.replaceFirst('GetMaterialApp(', 
        'GetMaterialApp(\\n        initialRoute: AppPages.INITIAL,\\n        getPages: AppPages.routes,');
    }

    file.writeAsStringSync(content);
  }

  static void _createFiles(String baseDir, String snakeName, String pascalName) {
    // Controller
    File(p.join(baseDir, 'controller', '${snakeName}_controller.dart')).writeAsStringSync('''
import 'package:get/get.dart';

class ${pascalName}Controller extends GetxController {
  final count = 0.obs;
}
''');

    // View
    File(p.join(baseDir, 'view', '${snakeName}_page.dart')).writeAsStringSync('''
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/${snakeName}_controller.dart';

class ${pascalName}Page extends GetView<${pascalName}Controller> {
  const ${pascalName}Page({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('${pascalName}')),
      body: Center(child: Obx(() => Text('Count: \${controller.count}'))),
    );
  }
}
''');

    // Binding
    File(p.join(baseDir, 'binding', '${snakeName}_binding.dart')).writeAsStringSync('''
import 'package:get/get.dart';
import '../controller/${snakeName}_controller.dart';

class ${pascalName}Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<${pascalName}Controller>(() => ${pascalName}Controller());
  }
}
''');
  }

  static void _injectRoutes(String snakeName, String pascalName) {
    final routesFile = File('lib/core/routes/app_routes.dart');
    final pagesFile = File('lib/core/routes/app_pages.dart');

    if (routesFile.existsSync()) {
      String content = routesFile.readAsStringSync();
      if (!content.contains(snakeName)) {
        content = content.replaceFirst('// [GEN_ROUTES]', 
          'static const String $snakeName = \'/$snakeName\';\n  // [GEN_ROUTES]');
        routesFile.writeAsStringSync(content);
      }
    }

    if (pagesFile.existsSync()) {
      String content = pagesFile.readAsStringSync();
      if (!content.contains(pascalName)) {
        content = content.replaceFirst('// [GEN_IMPORTS]', 
          'import \'../../features/$snakeName/view/${snakeName}_page.dart\';\nimport \'../../features/$snakeName/binding/${snakeName}_binding.dart\';\n// [GEN_IMPORTS]');
        content = content.replaceFirst('// [GEN_PAGES]', 
          '''GetPage(
      name: AppRoutes.$snakeName,
      page: () => const ${pascalName}Page(),
      binding: ${pascalName}Binding(),
    ),
    // [GEN_PAGES]''');
        pagesFile.writeAsStringSync(content);
      }
    }
  }
}
