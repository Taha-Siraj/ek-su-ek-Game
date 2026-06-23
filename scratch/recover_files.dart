import 'dart:convert';
import 'dart:io';

void main() {
  final transcriptFile = File(r'C:\Users\UCom\.gemini\antigravity-ide\brain\c0487430-c047-4474-9442-86bc68c4a2a9\.system_generated\logs\transcript.jsonl');
  if (!transcriptFile.existsSync()) {
    print("Transcript file not found!");
    return;
  }

  final targetFiles = [
    'global_leaderboard_screen.dart',
    'login_guest_access_screen.dart',
    'splash_screen.dart',
    'splash_screen_animated.dart',
    'victory_screen_animated.dart',
  ];

  final Map<String, String> recoveredCode = {};
  final Map<String, int> lastStep = {};

  final lines = transcriptFile.readAsLinesSync();
  print("Read ${lines.length} lines from transcript.");

  for (int lineIdx = 0; lineIdx < lines.length; lineIdx++) {
    final line = lines[lineIdx].trim();
    if (line.isEmpty) continue;

    try {
      final jsonMap = json.decode(line) as Map<String, dynamic>;
      final stepIndex = jsonMap['step_index'] ?? lineIdx;
      
      final toolCalls = jsonMap['tool_calls'];
      if (toolCalls is List) {
        for (final call in toolCalls) {
          if (call is Map<String, dynamic>) {
            final args = call['args'];
            if (args is Map<String, dynamic>) {
              String targetFile = args['TargetFile'] ?? args['target_file'] ?? '';
              targetFile = targetFile.replaceAll('"', '').trim().toLowerCase();
              
              if (targetFile.contains('splash_screen.dart')) {
                print("Step $stepIndex: Found splash_screen.dart | targetFile: $targetFile");
              }

              for (final targetName in targetFiles) {
                final matchName = targetName.toLowerCase();
                final doesMatch = targetFile.endsWith(matchName);
                if (doesMatch) {
                  String code = args['CodeContent'] ?? '';
                  if (code.isNotEmpty) {
                    if (code.startsWith('"') && code.endsWith('"')) {
                      try {
                        final decodedList = json.decode('[$code]') as List;
                        code = decodedList[0] as String;
                      } catch (e) {
                        code = code.substring(1, code.length - 1)
                          .replaceAll(r'\n', '\n')
                          .replaceAll(r'\"', '"')
                          .replaceAll(r'\\', '\\');
                      }
                    }
                    
                    if (!code.contains('<truncated')) {
                      final existingLength = recoveredCode[targetName]?.length ?? 0;
                      if (code.length > existingLength) {
                        recoveredCode[targetName] = code;
                        lastStep[targetName] = stepIndex;
                        print("Saved $targetName at step $stepIndex | length: ${code.length}");
                      }
                    } else {
                      print("Step $stepIndex: Code contains truncated marker!");
                    }
                  } else {
                    print("Step $stepIndex: CodeContent is empty!");
                  }
                }
              }
            }
          }
        }
      }
    } catch (e) {
      // ignore
    }
  }

  // Write recovered files back to disk
  for (final entry in recoveredCode.entries) {
    final targetName = entry.key;
    final code = entry.value;
    final step = lastStep[targetName];

    final File diskFile = File('lib/screens/$targetName');
    diskFile.writeAsStringSync(code);
    print("Recovered $targetName from step $step (length: ${code.length} chars)");
  }
}
