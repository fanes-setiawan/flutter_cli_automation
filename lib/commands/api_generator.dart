import 'dart:io';
import 'package:path/path.dart' as p;
import '../utils/string_utils.dart';

class ApiGenerator {
  static void addApi(String name, String method) {
    final currentDir = Directory.current.path;
    final pascalName = name.toPascalCase();
    
    if (_isGetX(currentDir)) {
      _injectGetX(currentDir, name, pascalName, method);
    } else if (_isBloc(currentDir)) {
      _injectBloc(currentDir, name, pascalName, method);
    } else {
      print('❌ ERROR: Jalankan perintah ini di dalam folder bloc atau controller fitur!');
    }
  }

  static bool _isGetX(String path) => Directory(path).listSync().any((f) => f.path.endsWith('_controller.dart'));
  static bool _isBloc(String path) => Directory(path).listSync().any((f) => f.path.endsWith('_bloc.dart'));

  static void _injectGetX(String dir, String name, String pascalName, String method) {
    final file = Directory(dir).listSync().firstWhere((f) => f.path.endsWith('_controller.dart')) as File;
    String content = file.readAsStringSync();
    
    final newFunc = '''
  // Logic for $pascalName
  final is${pascalName}Loading = false.obs;
  Future<void> $name() async {
    try {
      is${pascalName}Loading.value = true;
      final response = await Dio().${method.toLowerCase()}(
        'YOUR_API_URL',
        options: Options(headers: {'Authorization': 'Bearer YOUR_TOKEN'}),
      );
      is${pascalName}Loading.value = false;
    } catch (e) {
      is${pascalName}Loading.value = false;
      rethrow;
    }
  }
''';
    int lastBrace = content.lastIndexOf('}');
    content = content.substring(0, lastBrace) + newFunc + content.substring(lastBrace);
    file.writeAsStringSync(content);
    print('✅ GetX: Fungsi $method dengan Header Token ditambahkan!');
  }

  static void _injectBloc(String dir, String name, String pascalName, String method) {
    final files = Directory(dir).listSync();
    final blocFile = files.firstWhere((f) => f.path.endsWith('_bloc.dart')) as File;
    final eventFile = files.firstWhere((f) => f.path.endsWith('_event.dart')) as File;
    final stateFile = files.firstWhere((f) => f.path.endsWith('_state.dart')) as File;

    final baseEvent = p.basenameWithoutExtension(eventFile.path).toPascalCase();
    final baseState = p.basenameWithoutExtension(stateFile.path).toPascalCase();

    // 1. Update Event
    String eventContent = eventFile.readAsStringSync();
    eventFile.writeAsStringSync(eventContent + '\nclass ${pascalName}Requested extends $baseEvent {}\n');

    // 2. Update State
    String stateContent = stateFile.readAsStringSync();
    stateFile.writeAsStringSync(stateContent + '''
class ${pascalName}Loading extends $baseState {}
class ${pascalName}Success extends $baseState {
  final dynamic data;
  ${pascalName}Success(this.data);
}
class ${pascalName}Failure extends $baseState {
  final String message;
  ${pascalName}Failure(this.message);
}
''');

    // 3. Update Bloc
    String blocContent = blocFile.readAsStringSync();
    String handler = '''
    on<${pascalName}Requested>((event, emit) async {
      try {
        emit(${pascalName}Loading());
        final response = await Dio().${method.toLowerCase()}(
          'YOUR_API_URL',
          options: Options(headers: {'Authorization': 'Bearer YOUR_TOKEN'}),
        );
        emit(${pascalName}Success(response.data));
      } catch (e) {
        emit(${pascalName}Failure(e.toString()));
      }
    });\n''';

    int lastBrace = blocContent.lastIndexOf('}');
    blocContent = blocContent.substring(0, lastBrace) + handler + blocContent.substring(lastBrace);
    blocFile.writeAsStringSync(blocContent);
    
    print('✅ BLoC: Logic $method dengan Header Token ditambahkan!');
  }
}
