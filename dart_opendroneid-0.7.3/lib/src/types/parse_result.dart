import 'odid_message.dart';
import 'parse_warning.dart';

class ParseResult<T extends ODIDMessage> {
  final T message;
  final List<ParseWarning> warnings;

  ParseResult({
    required this.message,
    required this.warnings,
  });

  bool get hasWarnings => warnings.isNotEmpty;

  bool get hasSevereWarnings => warnings.any((warning) => warning.isSevere);

  @override
  String toString() {
    return 'ParseResult {message: $message, warnings: $warnings }';
  }
}
