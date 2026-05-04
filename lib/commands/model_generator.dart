import 'dart:io';
import 'package:path/path.dart' as p;
import '../utils/string_utils.dart';

class ModelGenerator {
  static void generate(String name) {
    final pascalName = name.toPascalCase();
    final snakeName = name.toSnakeCase();
    final dir = Directory('lib/core/models');
    
    if (!dir.existsSync()) dir.createSync(recursive: true);

    final file = File(p.join(dir.path, '${snakeName}_model.dart'));
    
    if (file.existsSync()) {
      print('⚠️ Model "$pascalName" sudah ada.');
      return;
    }

    file.writeAsStringSync('''
class ${pascalName}Model {
  final int? id;

  ${pascalName}Model({
    this.id,
  });

  factory ${pascalName}Model.fromJson(Map<String, dynamic> json) => ${pascalName}Model(
        id: json['id'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
      };
}
''');

    print('✅ Model ${pascalName}Model berhasil dibuat di lib/core/models/');
    print('💡 Tips: Tambahkan field lainnya sesuai kebutuhan API Anda.');
  }
}
