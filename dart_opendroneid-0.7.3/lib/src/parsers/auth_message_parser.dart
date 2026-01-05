import 'dart:typed_data';

import '../constants.dart';
import '../decoders/auth_message_decoders.dart';
import '../decoders/decoders.dart';
import '../enums.dart';
import '../types/odid_message.dart';
import '../types/parse_warning.dart';
import 'odid_message_parser.dart';

class AuthMessageParser extends ODIDMessageParser<AuthMessage> {
  final Uint8List _messageData;
  AuthMessageParser(Uint8List messageData) : _messageData = messageData;

  /// see comment above [AuthMessage] for explanation of the format
  @override
  AuthMessage parseImpl() {
    final protocolVersion =
        decodeField(decodeProtocolVersion, _messageData, 0, 1);
    final authTypeValueRaw = (_messageData[1] & 0xF0) >> 4;
    final authType = AuthType.getByValue(authTypeValueRaw);

    // FIXME: validate protocol version here

    if (authType == null) {
      warn(ParseWarning.severe(WarnMessages.unknownFieldValue('AuthType',
          actualValue: authTypeValueRaw)));
    }

    int? pageNumber = _messageData[1] & 0x0F;
    int? lastPageIndex;
    int? authLength;
    DateTime? timestamp;
    int? authDataOffset;
    int? currMessageAuthLength;

    if (pageNumber == 0) {
      lastPageIndex = _messageData[2] & 0x0F;
      authLength = _messageData[3];
      timestamp = decodeField(decodeODIDEpochTimestamp, _messageData, 4, 8);

      if (lastPageIndex >= maxAuthDataPages ||
          authLength > maxAuthPageZeroSize) {
        warn(ParseWarning.severe(
            WarnMessages.authenticationMessageExceedsMaxSizes));
      }

      authDataOffset = 8;
      currMessageAuthLength = maxAuthPageZeroSize;
    } else {
      authDataOffset = 2;
      currMessageAuthLength = maxAuthPageNonZeroSize;
    }

    final authData = decodeField(
      decodeAuthData,
      _messageData,
      authDataOffset,
      authDataOffset + currMessageAuthLength,
    );

    return AuthMessage(
      protocolVersion: protocolVersion,
      rawContent: _messageData,
      authType: authType ?? AuthType.none,
      authPageNumber: pageNumber,
      lastAuthPageIndex: lastPageIndex,
      authLength: authLength,
      timestamp: timestamp,
      authData: authData,
    );
  }
}
