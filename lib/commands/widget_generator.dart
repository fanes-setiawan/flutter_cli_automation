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
  final String? Function(String?)? validator;
  const CustomPasswordField({super.key, required this.label, this.controller, this.validator});
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
      validator: widget.validator,
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
    print('✅ Widget Password berhasil dibuat di lib/core/widgets/');
  }

  static void generateEmail() {
    final dir = Directory('lib/core/widgets');
    if (!dir.existsSync()) dir.createSync(recursive: true);

    File('lib/core/widgets/custom_email_field.dart').writeAsStringSync('''
import 'package:flutter/material.dart';

class CustomEmailField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  const CustomEmailField({super.key, required this.label, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Email tidak boleh kosong';
        final emailRegex = RegExp(r'^[^@]+@[^@]+\\.[^@]+');
        if (!emailRegex.hasMatch(value)) return 'Format email salah';
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.email),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
''');
    print('✅ Widget Email berhasil dibuat di lib/core/widgets/');
  }
}
