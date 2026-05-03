import 'dart:io';
import 'package:path/path.dart' as p;
import '../utils/string_utils.dart';

class BlocGenerator {
  static void generate(String name) {
    final snakeName = name.toSnakeCase();
    final pascalName = name.toPascalCase();
    final baseDir = p.join('lib', 'features', snakeName);

    if (Directory(baseDir).existsSync()) {
      print('⚠️ Feature "$snakeName" sudah ada.');
      return;
    }

    // Create folders
    final folders = ['bloc', 'ui'];
    for (var folder in folders) {
      Directory(p.join(baseDir, folder)).createSync(recursive: true);
    }

    _createFiles(baseDir, snakeName, pascalName);

    // OTOMATIS DAFTARKAN KE app_providers.dart
    _injectProvider(snakeName, pascalName);

    print('✅ Berhasil membuat BLoC Feature: $pascalName & Terdaftar di AppProviders');
  }

  static void _createFiles(String baseDir, String snakeName, String pascalName) {
    File(p.join(baseDir, 'bloc', '${snakeName}_bloc.dart')).writeAsStringSync('''
import 'package:flutter_bloc/flutter_bloc.dart';
import '${snakeName}_event.dart';
import '${snakeName}_state.dart';

class ${pascalName}Bloc extends Bloc<${pascalName}Event, ${pascalName}State> {
  ${pascalName}Bloc() : super(${pascalName}Initial()) {
    on<${pascalName}Started>((event, emit) {
      // TODO: implement event handler
    });
  }
}
''');

    File(p.join(baseDir, 'bloc', '${snakeName}_event.dart')).writeAsStringSync('''
abstract class ${pascalName}Event {}
class ${pascalName}Started extends ${pascalName}Event {}
''');

    File(p.join(baseDir, 'bloc', '${snakeName}_state.dart')).writeAsStringSync('''
abstract class ${pascalName}State {}
class ${pascalName}Initial extends ${pascalName}State {}
''');

    File(p.join(baseDir, 'ui', '${snakeName}_page.dart')).writeAsStringSync('''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/${snakeName}_bloc.dart';
import '../bloc/${snakeName}_state.dart';

class ${pascalName}Page extends StatelessWidget {
  const ${pascalName}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('${pascalName}')),
      body: BlocBuilder<${pascalName}Bloc, ${pascalName}State>(
        builder: (context, state) {
          return const Center(child: Text('BLoC Page'));
        },
      ),
    );
  }
}
''');
  }

  static void _injectProvider(String snakeName, String pascalName) {
    final file = File('lib/app_providers.dart');
    if (!file.existsSync()) return;

    String content = file.readAsStringSync();
    if (!content.contains(pascalName)) {
      // Inject Import
      content = content.replaceFirst('// [GEN_IMPORTS]', 
        'import \'features/$snakeName/bloc/${snakeName}_bloc.dart\';\n// [GEN_IMPORTS]');
      
      // Inject Provider
      content = content.replaceFirst('// [GEN_PROVIDERS]', 
        'BlocProvider(create: (context) => ${pascalName}Bloc()),\n    // [GEN_PROVIDERS]');
      
      file.writeAsStringSync(content);
    }
  }
}
