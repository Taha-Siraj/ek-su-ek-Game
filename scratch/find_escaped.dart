import 'dart:io';

void main() {
  final dir = Directory('lib');
  if (!dir.existsSync()) {
    print("lib directory not found!");
    return;
  }
  
  final files = dir.listSync(recursive: true);
  for (final entity in files) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final content = entity.readAsStringSync().trim();
      if (content.startsWith('"') || content.startsWith('\'"')) {
        print("Escaped: ${entity.path}");
      }
    }
  }
}
