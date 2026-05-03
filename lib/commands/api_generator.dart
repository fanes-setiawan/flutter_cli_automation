import 'dart:io';
import 'package:path/path.dart' as p;
import '../utils/string_utils.dart';

class ApiGenerator {
  static void addApi(String name, String method) {
    var currentDir = Directory.current.path;
    final pascalName = name.toPascalCase();
    
    String? targetDir = _findTargetDir(currentDir);

    if (targetDir != null) {
      if (_isGetX(targetDir)) {
        _injectGetX(targetDir, name, pascalName, method);
      } else if (_isBloc(targetDir)) {
        _injectBloc(targetDir, name, pascalName, method);
      }
    } else {
      print('❌ ERROR: Jalankan perintah ini di dalam folder fitur, bloc, atau controller!');
    }
  }

  static String? _findTargetDir(String startPath) {
    if (_isGetX(startPath) || _isBloc(startPath)) return startPath;
    final blocDir = p.join(startPath, 'bloc');
    if (Directory(blocDir).existsSync() && _isBloc(blocDir)) return blocDir;
    final controllerDir = p.join(startPath, 'controller');
    if (Directory(controllerDir).existsSync() && _isGetX(controllerDir)) return controllerDir;
    return null;
  }

  static bool _isGetX(String path) => Directory(path).listSync().any((f) => f.path.endsWith('_controller.dart'));
  static bool _isBloc(String path) => Directory(path).listSync().any((f) => f.path.endsWith('_bloc.dart'));

  static void _injectGetX(String dir, String name, String pascalName, String method) {
    final file = Directory(dir).listSync().firstWhere((f) => f.path.endsWith('_controller.dart')) as File;
    String content = file.readAsStringSync();
    
    // Inject Dio Import
    if (!content.contains('package:dio/dio.dart')) {
      content = "import 'package:dio/dio.dart';\n" + content;
    }

    final dataTemplate = method == 'POST' ? 'data: {\'key\': \'value\'},' : '';

    final newFunc = '''

  // Logic for $pascalName
  final is${pascalName}Loading = false.obs;
  Future<void> $name({dynamic requestData}) async {
    try {
      is${pascalName}Loading.value = true;
      final response = await Dio().${method.toLowerCase()}(
        'YOUR_API_URL',
        $dataTemplate
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
  }

  static void _injectBloc(String dir, String name, String pascalName, String method) {
    final files = Directory(dir).listSync();
    final blocFile = files.firstWhere((f) => f.path.endsWith('_bloc.dart')) as File;
    final eventFile = files.firstWhere((f) => f.path.endsWith('_event.dart')) as File;
    final stateFile = files.firstWhere((f) => f.path.endsWith('_state.dart')) as File;

    final baseEvent = p.basenameWithoutExtension(eventFile.path).toPascalCase();
    final baseState = p.basenameWithoutExtension(stateFile.path).toPascalCase();
    final className = p.basenameWithoutExtension(blocFile.path).toPascalCase();

    // 1. Update Event & State (Sama seperti sebelumnya)
    eventFile.writeAsStringSync(eventFile.readAsStringSync() + '\nclass ${pascalName}Requested extends $baseEvent {}\n');
    stateFile.writeAsStringSync(stateFile.readAsStringSync() + '\nclass ${pascalName}Loading extends $baseState {}\nclass ${pascalName}Success extends $baseState { final dynamic data; ${pascalName}Success(this.data); }\nclass ${pascalName}Failure extends $baseState { final String message; ${pascalName}Failure(this.message); }\n');

    // 2. Update BLoC File
    String bContent = blocFile.readAsStringSync();

    // Inject Dio Import
    if (!bContent.contains('package:dio/dio.dart')) {
      bContent = "import 'package:dio/dio.dart';\n" + bContent;
    }

    // Inject Dio Field
    if (!bContent.contains('final Dio dio;')) {
      int classStart = bContent.indexOf('class $className');
      int firstBrace = bContent.indexOf('{', classStart) + 1;
      bContent = bContent.substring(0, firstBrace) + '\n  final Dio dio;' + bContent.substring(firstBrace);
    }

    // Update Constructor to use {required this.dio}
    if (!bContent.contains('this.dio')) {
      bContent = bContent.replaceFirst('$className()', '$className({required this.dio})');
    }

    final dioData = method == 'POST' ? 'data: event.data,' : '';
    String handler = '''
    on<${pascalName}Requested>((event, emit) async {
      try {
        emit(${pascalName}Loading());
        final response = await dio.${method.toLowerCase()}(
          'YOUR_API_URL',
          $dioData
          options: Options(headers: {'Authorization': 'Bearer YOUR_TOKEN'}),
        );
        emit(${pascalName}Success(response.data));
      } catch (e) {
        emit(${pascalName}Failure(e.toString()));
      }
    });\n''';

    int superIdx = bContent.indexOf('super(');
    if (superIdx != -1) {
      int openBraceIdx = bContent.indexOf('{', superIdx);
      if (openBraceIdx != -1) {
        int closingBraceIdx = _findClosingBrace(bContent, openBraceIdx);
        if (closingBraceIdx != -1) {
          bContent = bContent.substring(0, closingBraceIdx) + handler + bContent.substring(closingBraceIdx);
          blocFile.writeAsStringSync(bContent);
          print('✅ BLoC: Logic DI Dio & $method $name berhasil ditambahkan!');
          return;
        }
      }
    }
    
    blocFile.writeAsStringSync(bContent);
  }

  static int _findClosingBrace(String text, int openBraceIdx) {
    int count = 0;
    for (int i = openBraceIdx; i < text.length; i++) {
      if (text[i] == '{') count++;
      if (text[i] == '}') count--;
      if (count == 0) return i;
    }
    return -1;
  }
}
