import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as p;
import '../lib/commands/bloc_generator.dart';
import '../lib/commands/getx_generator.dart';
import '../lib/commands/init_generator.dart';
import '../lib/commands/guide_generator.dart';
import '../lib/commands/widget_generator.dart';
import '../lib/commands/hive_generator.dart';
import '../lib/commands/api_generator.dart';

const String cliVersion = '1.0.8';

void main(List<String> arguments) {
  final parser = ArgParser();
  parser.addCommand('init');
  parser.addCommand('guide');
  parser.addCommand('version');
  parser.addCommand('w-password');
  parser.addCommand('w-email');
  parser.addCommand('w-button');
  parser.addCommand('w-form-name');
  parser.addCommand('h-init');
  
  final postCommand = parser.addCommand('add-post');
  postCommand.addOption('name', abbr: 'n', help: 'Nama fungsi API');

  final getCommand = parser.addCommand('add-get');
  getCommand.addOption('name', abbr: 'n', help: 'Nama fungsi API');

  final blocCommand = parser.addCommand('bloc');
  blocCommand.addOption('name', abbr: 'n', help: 'Nama feature');
  final getxCommand = parser.addCommand('getx');
  getxCommand.addOption('name', abbr: 'n', help: 'Nama feature');

  try {
    final results = parser.parse(arguments);
    final commandName = results.command?.name;

    if (commandName == 'version') {
      print('🚀 Fanes-Code CLI Version: $cliVersion');
      return;
    }
    if (commandName == 'guide') {
      GuideGenerator.show();
      return;
    }

    // Ambil path folder saat ini (untuk add-post)
    final originalCwd = Directory.current.path;

    // Smart Root Detection (Cari pubspec.yaml)
    if (!_findAndSetProjectRoot()) {
      print('❌ ERROR: Jalankan perintah ini di dalam project Flutter!');
      _showUsage();
      return;
    }

    if (commandName == 'w-password') {
      WidgetGenerator.generatePassword();
    } else if (commandName == 'w-email') {
      WidgetGenerator.generateEmail();
    } else if (commandName == 'w-button') {
      WidgetGenerator.generateButton();
    } else if (commandName == 'w-form-name') {
      WidgetGenerator.generateFormName();
    } else if (commandName == 'h-init') {
      HiveGenerator.generate();
    } else if (commandName == 'add-post') {
      final name = results.command!['name'];
      if (name == null) return _showUsage();
      // Jalankan API generator di folder asli user
      Directory.current = originalCwd; 
      ApiGenerator.addApi(name, 'POST');
    } else if (commandName == 'add-get') {
      final name = results.command!['name'];
      if (name == null) return _showUsage();
      Directory.current = originalCwd;
      ApiGenerator.addApi(name, 'GET');
    } else if (commandName == 'init') {
      InitGenerator.generate();
    } else if (commandName == 'bloc') {
      final name = results.command!['name'];
      if (name == null) return _showUsage();
      BlocGenerator.generate(name);
    } else if (commandName == 'getx') {
      final name = results.command!['name'];
      if (name == null) return _showUsage();
      GetXGenerator.generate(name);
    } else {
      _showUsage();
    }
  } catch (e) {
    _showUsage();
  }
}

bool _findAndSetProjectRoot() {
  var dir = Directory.current;
  while (true) {
    if (File(p.join(dir.path, 'pubspec.yaml')).existsSync()) {
      Directory.current = dir; 
      return true;
    }
    if (dir.path == dir.parent.path) break;
    dir = dir.parent;
  }
  return false;
}

void _showUsage() {
  print('\x1B[33m' + '🚀 Fanes-Code CLI [v$cliVersion]' + '\x1B[0m');
  print('Modern Flutter Scaffolding Tool by Fanes-Code\n');
  
  print('\x1B[32mUsage:\x1B[0m');
  print('  fanes-cli <command> [options]\n');

  print('\x1B[32mAvailable Commands:\x1B[0m');
  print('  \x1B[36minit\x1B[0m             : Setup folder core, routes, & providers');
  print('  \x1B[36mbloc -n <nama>\x1B[0m   : Create BLoC feature (Auto register provider)');
  print('  \x1B[36mgetx -n <nama>\x1B[0m   : Create GetX feature (Auto register routes)');
  print('  \x1B[36madd-post -n <nm>\x1B[0m : Inject POST API Scaffolding');
  print('  \x1B[36madd-get -n <nm>\x1B[0m  : Inject GET API Scaffolding');
  print('  \x1B[36mw-password\x1B[0m       : Create Password Field Widget');
  print('  \x1B[36mw-email\x1B[0m          : Create Email Field Widget');
  print('  \x1B[36mw-button\x1B[0m         : Create Custom Button Widget');
  print('  \x1B[36mw-form-name\x1B[0m      : Create Name Field Widget');
  print('  \x1B[36mh-init\x1B[0m           : Setup Hive Local Storage');
  print('  \x1B[36mguide\x1B[0m            : Lihat tutorial lengkap & contoh penggunaan');
  print('  \x1B[36mversion\x1B[0m          : Tampilkan versi CLI saat ini\n');

  print('\x1B[33m💡 Tips:\x1B[0m Jalankan \x1B[32mfanes-cli guide\x1B[0m untuk panduan mendalam.');
}
