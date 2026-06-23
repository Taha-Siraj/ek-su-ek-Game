import 'dart:convert';
import 'dart:io';

void main() {
  final files = [
    'lib/screens/global_leaderboard_screen.dart',
    'lib/screens/login_guest_access_screen.dart',
    'lib/screens/splash_screen.dart',
    'lib/screens/splash_screen_animated.dart',
    'lib/screens/victory_screen_animated.dart',
  ];

  for (final filePath in files) {
    final file = File(filePath);
    if (file.existsSync()) {
      String content = file.readAsStringSync().trim();
      
      if (content.startsWith('"')) {
        // Wrap in array brackets if needed to decode safely
        try {
          final decoded = json.decode('[$content]') as List;
          final rawString = decoded[0] as String;
          file.writeAsStringSync(rawString);
          print("Successfully unescaped: $filePath");
        } catch (e) {
          print("Error decoding $filePath: $e. Trying manual replacement.");
          // Try manual unescape if json decode fails
          String rawString = content.substring(1, content.length - 1)
            .replaceAll(r'\n', '\n')
            .replaceAll(r'\"', '"')
            .replaceAll(r'\\', '\\');
          file.writeAsStringSync(rawString);
          print("Manually unescaped: $filePath");
        }
      } else {
        print("File not escaped: $filePath");
      }
    }
  }
}
