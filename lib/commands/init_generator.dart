import 'dart:io';

class InitGenerator {
  static void generate() {
    final folders = [
      'lib/core/theme',
      'lib/core/widgets',
      'lib/core/constants',
      'lib/core/utils',
      'lib/core/routes',
      'lib/features',
    ];

    for (var folder in folders) {
      Directory(folder).createSync(recursive: true);
    }

    // Buat app_providers.dart untuk BLoC
    _createAppProviders();

    File('lib/core/routes/app_routes.dart').writeAsStringSync('''
class AppRoutes {
  static const String initial = '/';
  // [GEN_ROUTES]
}
''');

    File('lib/core/routes/app_pages.dart').writeAsStringSync('''
import 'package:get/get.dart';
import 'app_routes.dart';
// [GEN_IMPORTS]

class AppPages {
  static const INITIAL = AppRoutes.initial;
  static final routes = [
    // [GEN_PAGES]
  ];
}
''');

    print('✅ Struktur folder & File utama (Providers & Routes) berhasil dibuat!');
    print('💡 Tips: Panggil "AppProviders.providers" di MultiBlocProvider pada main.dart Anda.');
  }

  static void _createAppProviders() {
    final file = File('lib/app_providers.dart');
    if (!file.existsSync()) {
      file.writeAsStringSync('''
import 'package:flutter_bloc/flutter_bloc.dart';
// [GEN_IMPORTS]

class AppProviders {
  static final providers = [
    // [GEN_PROVIDERS]
  ];
}
''');
    }
  }
}
