import 'dart:typed_data';

import 'constants.dart';
import 'exceptions.dart';
import 'parsers/auth_message_parser.dart';
import 'parsers/basic_id_message_parser.dart';
import 'parsers/location_message_parser.dart';
import 'parsers/message_pack_parser.dart';
import 'parsers/odid_message_parser.dart';
import 'parsers/operator_id_message_parser.dart';
import 'parsers/self_id_message_parser.dart';
import 'parsers/system_message_parser.dart';
import 'validators/odid_message_validator.dart';
import 'validators/location_message_validator.dart';
import 'validators/system_message_validator.dart';
import 'validators/operator_id_message_validator.dart';
import 'types.dart';

final Map<Type, ODIDMessageParser Function(Uint8List)> _parserFactories = {
  BasicIDMessage: (data) => BasicIDMessageParser(data),
  LocationMessage: (data) => LocationMessageParser(data),
  AuthMessage: (data) => AuthMessageParser(data),
  SelfIDMessage: (data) => SelfIDMessageParser(data),
  SystemMessage: (data) => SystemMessageParser(data),
  OperatorIDMessage: (data) => OperatorIDMessageParser(data),
  MessagePack: (data) => MessagePackParser(data),
};

const Map<Type, ODIDMessageValidator> _validatorMapping = {
  LocationMessage: LocationMessageValidator(),
  OperatorIDMessage: OperatorIDMessageValidator(),
  SystemMessage: SystemMessageValidator(),
};

/// Parses ODID message from array of raw bytes [messageData].
/// Optional parameter [T] can constrain the expected message type.
/// Returns [ParseResult] containing the parsed message and any warnings.
/// Any parsing errors preventing the message to be constructed will be
/// thrown as exceptions, subclasses of [OdidMessageParseError].
///
/// NOTE: Since x.x this method started raising exceptions instead of `null`
/// and returns [ParseResult]. After upgrading to >=x.x, if you wish to keep
/// the same behavior, replace with [tryParseOdidMessage].
ParseResult<T> parseODIDMessage<T extends ODIDMessage>(Uint8List messageData) {
  final messageType = determineODIDMessageType(messageData);

  // If [T] is specified, check that the parsed message type matches
  if (T != ODIDMessage && messageType is! T) {
    throw UnexpectedOdidMessageType(T, messageType);
  }

  // Check that message length is exact for non-pack messages
  if (messageType != MessagePack && messageData.length != maxMessageSize) {
    throw OdidMessageLengthMismatch(messageData.length,
        expected: maxMessageSize);
  }

  final parserFactory = _parserFactories[messageType];

  if (parserFactory == null) {
    throw Exception('No parser found for message type $messageType');
  }

  final parser = parserFactory(messageData);
  final message = parser.parse();

  return ParseResult(
    message: message as T,
    warnings: parser.warnings,
  );
}

/// Tries to parse ODID message from array of raw bytes [messageData].
/// Optional parameter [T] can constrain the expected message type.
///
/// Returns [ParseResult] containing the parsed message and any warnings,
/// or `null` if there were any parsing errors preventing the message
/// to be constructed.
ParseResult<T>? tryParseODIDMessage<T extends ODIDMessage>(
    Uint8List messageData) {
  try {
    return parseODIDMessage(messageData);
  } on OdidMessageParseError {
    return null;
  }
}

/// stream (using [parseODIDMessage]).
Stream<ParseResult> parseODIDMessageStream(Stream<Uint8List> messageStream) =>
    messageStream
        .map(tryParseODIDMessage)
        .where((r) => r != null)
        .cast<ParseResult>();

/// Returns ODID message type based on received message header.
/// Throws an exception if unable to determine.
Type determineODIDMessageType(Uint8List messageData) {
  // Each message has to be min. 25 bytes
  if (messageData.length < maxMessageSize) {
    throw OdidMessageLengthMismatch(messageData.length);
  }

  // Header is always the first byte
  final header = messageData[0];

  // First 4 bits encode message type
  final type = (header & 0xF0) >> 4;
  final messageType = MessageType.getByValue(type);

  if (messageType == null) {
    throw UnknownOdidMessageType(type);
  }

  return messageType.toODIDMessageType();
}

/// Filters out [ODIDMessage] with invalid, corrupted or incomplete data.
Stream<ODIDMessage?> filterODIDMessageStream(
        Stream<ODIDMessage?> messageStream) =>
    messageStream
        .map((message) => validateODIDMessage(message) ? message : null);

/// Validate [ODIDMessage] by verifying that values are in allowed limits
/// and are not equal to known invalid values.
/// Returns true if message is valid.
bool validateODIDMessage(ODIDMessage? message) {
  if (message == null) return false;

  final validator = _validatorMapping[message.runtimeType];

  // no validator, valid by dafault
  if (validator == null) {
    return true;
  }

  return validator.validate(message);
}
