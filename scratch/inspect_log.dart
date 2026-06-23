import 'dart:convert';
import 'dart:io';

void main() {
  final file = File(r'C:\Users\UCom\.gemini\antigravity-ide\brain\c0487430-c047-4474-9442-86bc68c4a2a9\.system_generated\logs\transcript.jsonl');
  final lines = file.readAsLinesSync();
  for (final line in lines) {
    if (line.contains('write_to_file') && line.contains('splash_screen.dart')) {
      try {
        final map = json.decode(line) as Map<String, dynamic>;
        final toolCalls = map['tool_calls'];
        if (toolCalls is List) {
          for (final call in toolCalls) {
            final args = call['args'];
            if (args is Map) {
              final tf = args['TargetFile'] ?? args['target_file'] ?? '';
              if (tf.contains('splash_screen.dart')) {
                print("Args keys: ${args.keys}");
                for (final key in args.keys) {
                  final val = args[key];
                  final valStr = val.toString();
                  print("  Key: $key | Type: ${val.runtimeType} | Length: ${valStr.length} | Preview: ${valStr.substring(0, valStr.length > 50 ? 50 : valStr.length)}");
                }
              }
            }
          }
        }
      } catch (e) {}
    }
  }
}
