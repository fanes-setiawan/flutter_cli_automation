extension StringExtensions on String {
  String toSnakeCase() {
    return replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (Match m) => '\${m[1]!}_\${m[2]!}').toLowerCase();
  }

  String toPascalCase() {
    return split(RegExp(r'(_|-| )'))
        .map((str) => str[0].toUpperCase() + str.substring(1))
        .join();
  }
}
