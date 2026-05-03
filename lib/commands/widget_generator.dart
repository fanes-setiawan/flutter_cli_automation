import 'dart:io';

class WidgetGenerator {
  static void generatePassword() {
    final dir = Directory('lib/core/widgets');
    if (!dir.existsSync()) dir.createSync(recursive: true);

    File('lib/core/widgets/custom_password_field.dart').writeAsStringSync('''
import 'package:flutter/material.dart';

class CustomPasswordField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  const CustomPasswordField({super.key, required this.label, this.controller});
  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ),
      ),
    );
  }
}
''');
    print('✅ Widget Password berhasil dibuat!');
  }
}
