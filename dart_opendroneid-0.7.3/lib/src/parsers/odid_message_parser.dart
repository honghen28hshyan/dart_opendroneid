import '../types/odid_message.dart';
import '../types/parse_warning.dart';

abstract class ODIDMessageParser<T extends ODIDMessage> {
  /// List of warnings that occurred during parsing
  List<ParseWarning> warnings = [];

  bool get hasWarnings => warnings.isNotEmpty;

  ODIDMessageParser();

  /// Internal implementation of parsing the message data,
  /// returninh an instance of [ODIDMessage].
  /// NOTE: Sub-classes must implement this method.
  T parseImpl();

  /// Parses the OpenDroneID message from the raw data.
  ///
  /// Returns an instance of [ODIDMessage] or throws an exception
  /// if the message cannot be parsed. If there are any warnings
  /// during parsing, that didn't prevented the parsing, they can be
  /// accessed via the [warnings] property.
  T parse() {
    warnings.clear();
    final parsedMessage = parseImpl();

    return parsedMessage;
  }

  /// Add new warning to the internal list of warnings.
  void warn(ParseWarning warning) {
    warnings.add(warning);
  }
}
