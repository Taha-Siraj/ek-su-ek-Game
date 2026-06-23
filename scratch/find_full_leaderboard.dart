import 'dart:convert';
import 'dart:io';

void main() {
  final file = File(r'C:\Users\UCom\.gemini\antigravity-ide\brain\c0487430-c047-4474-9442-86bc68c4a2a9\.system_generated\logs\transcript.jsonl');
  final lines = file.readAsLinesSync();
  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (line.contains('global_leaderboard_screen.dart')) {
      try {
        final map = json.decode(line) as Map<String, dynamic>;
        final step = map['step_index'] ?? i;
        final toolCalls = map['tool_calls'];
        if (toolCalls is List) {
          for (final call in toolCalls) {
            final args = call['args'];
            if (args is Map) {
              final tf = args['TargetFile'] ?? args['target_file'] ?? '';
              if (tf.contains('global_leaderboard_screen.dart')) {
                final code = args['CodeContent'] ?? args['ReplacementContent'] ?? '';
                final isTrunc = code.contains('<truncated');
                print("Step $step | Length: ${code.length} | Truncated: $isTrunc");
              }
            }
          }
        }
      } catch (e) {}
    }
  }
}
