import 'dart:io';
import 'package:args/args.dart';
import '../lib/commands/bloc_generator.dart';
import '../lib/commands/getx_generator.dart';
import '../lib/commands/init_generator.dart';
import '../lib/commands/guide_generator.dart';
import '../lib/commands/widget_generator.dart';
import '../lib/commands/hive_generator.dart';
import '../lib/commands/api_generator.dart';

const String cliVersion = '1.0.7';

void main(List<String> arguments) {
  final parser = ArgParser();
  parser.addCommand('init');
  parser.addCommand('guide');
  parser.addCommand('version');
  parser.addCommand('w-password');
  parser.addCommand('w-email');
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
    if (commandName == 'w-password') {
      WidgetGenerator.generatePassword();
      return;
    }
    if (commandName == 'w-email') {
      WidgetGenerator.generateEmail();
      return;
    }
    if (commandName == 'h-init') {
      HiveGenerator.generate();
      return;
    }
    if (commandName == 'add-post') {
      final name = results.command!['name'];
      if (name == null) return _showUsage();
      ApiGenerator.addApi(name, 'POST');
      return;
    }
    if (commandName == 'add-get') {
      final name = results.command!['name'];
      if (name == null) return _showUsage();
      ApiGenerator.addApi(name, 'GET');
      return;
    }

    if (!File('pubspec.yaml').existsSync()) {
      print('❌ ERROR: Jalankan perintah ini di root project Flutter!');
      _showUsage();
      return;
    }

    if (commandName == 'init') {
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

void _showUsage() {
  print('🚀 Welcome to Fanes-Code CLI! [v$cliVersion]');
  print('Usage:');
  print('  fanes-cli init             : Setup struktur folder awal');
  print('  fanes-cli guide            : Tampilkan panduan penggunaan');
  print('  fanes-cli version          : Tampilkan versi CLI');
  print('  fanes-cli w-password       : Create Password Field Widget');
  print('  fanes-cli w-email          : Create Email Field Widget');
  print('  fanes-cli h-init           : Setup Hive Local Storage');
  print('  fanes-cli add-post -n <nm> : Inject POST API Scaffolding');
  print('  fanes-cli add-get -n <nm>  : Inject GET API Scaffolding');
  print('  fanes-cli bloc -n <nama>   : Create BLoC feature');
  print('  fanes-cli getx -n <nama>   : Create GetX feature');
}
