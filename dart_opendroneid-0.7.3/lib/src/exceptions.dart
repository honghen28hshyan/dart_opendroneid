sealed class OdidMessageParseError implements Exception {
  final String message;

  const OdidMessageParseError(this.message);

  @override
  String toString() => 'Unable to parse ODID message: $message';
}

class OdidMessageLengthMismatch extends OdidMessageParseError {
  final int length;
  final int? expected;

  const OdidMessageLengthMismatch(this.length, {this.expected})
      : super('ODID message length mismatch of $length bytes'
            '${expected != null ? '($expected bytes expected)' : ''}');
}

class UnknownOdidMessageType extends OdidMessageParseError {
  final int messageType;

  const UnknownOdidMessageType(this.messageType)
      : super('Unknown ODID message type $messageType');
}

class UnexpectedOdidMessageType extends OdidMessageParseError {
  final Type expectedType;
  final Type actualType;
  const UnexpectedOdidMessageType(this.expectedType, this.actualType)
      : super('Expected message type $expectedType but got $actualType.');
}
