import 'dart:io';

class GuideGenerator {
  static void show() {
    print('\x1B[36m' + '==============================================' + '\x1B[0m');
    print('\x1B[33m' + '     🚀 FANES-CODE CLI TUTORIAL & GUIDE     ' + '\x1B[0m');
    print('\x1B[36m' + '==============================================' + '\x1B[0m');
    
    print('\n\x1B[32m1. Project Initialization\x1B[0m');
    print('   \$ fanes-cli init');
    print('   Gunakan ini di awal project untuk membuat folder core, routes,');
    print('   dan setup providers awal.');

    print('\n\x1B[32m2. Feature Generation (BLoC)\x1B[0m');
    print('   \$ fanes-cli bloc -n login');
    print('   Membuat folder feature login dengan struktur BLoC & UI.');
    print('   Otomatis mendaftarkan Bloc ke lib/app_providers.dart & Rute rute.');

    print('\n\x1B[32m3. Feature Generation (GetX)\x1B[0m');
    print('   \$ fanes-cli getx -n home');
    print('   Membuat folder feature home dengan Binding, Controller, & View.');
    print('   Otomatis mendaftarkan rute di app_routes.dart & app_pages.dart.');

    print('\n\x1B[32m4. API Scaffolding (Run inside feature folder)\x1B[0m');
    print('   \$ fanes-cli add-get -n get-user');
    print('   \$ fanes-cli add-post -n update-profile');
    print('   Menyuntikkan boilerplate API (Model, DataSource, Repo) secara instan.');

    print('\n\x1B[32m5. Local Storage (Hive)\x1B[0m');
    print('   \$ fanes-cli h-init');
    print('   Setup boilerplate Hive agar siap digunakan di project.');

    print('\n\x1B[32m6. UI Components\x1B[0m');
    print('   \$ fanes-cli w-password');
    print('   \$ fanes-cli w-email');
    print('   \$ fanes-cli w-button');
    print('   \$ fanes-cli w-form-name');
    print('   Membuat widget custom UI (Premium) di lib/core/widgets.');

    print('\n\x1B[36m' + '==============================================' + '\x1B[0m');
    print('💡 \x1B[33mTips:\x1B[0m Jalankan command di root project agar deteksi folder akurat!');
  }
}
