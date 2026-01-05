import 'dart:typed_data';

import '../constants.dart';
import '../dart_opendroneid.dart';
import '../decoders/decoders.dart';
import '../exceptions.dart';
import '../types/parse_warning.dart';
import '../types/odid_message.dart';
import 'odid_message_parser.dart';

class MessagePackParser extends ODIDMessageParser<MessagePack> {
  final Uint8List _messageData;
  final bool eagerFail;

  MessagePackParser(Uint8List messageData, {this.eagerFail = false})
      : _messageData = messageData;

  @override
  MessagePack parseImpl() {
    final protocolVersion =
        decodeField(decodeProtocolVersion, _messageData, 0, 1);

    // FIXME: validate protocol version here

    // Message pack contains metadata before actual message data
    // these include type, singleMessageSize and messageCount
    const packMetadataSize = 3;

    // Size of each message in pack (should always be 25)
    final singleMessageSize = _messageData[1];

    // Number of messages in this message pack
    final messageCount = _messageData[2];

    // Check if received data length checks out with header data
    final expectedLength =
        (singleMessageSize * messageCount) + packMetadataSize;
    if (_messageData.length != expectedLength) {
      throw OdidMessageLengthMismatch(_messageData.length,
          expected: expectedLength);
    }

    final List<ODIDMessage> messages = [];

    for (var i = 0; i < messageCount; i++) {
      final offset = packMetadataSize + (i * singleMessageSize);
      final singleMessageData =
          _messageData.sublist(offset, offset + singleMessageSize);

      try {
        final result = parseODIDMessage(singleMessageData);
        warnings.addAll(result.warnings);
        messages.add(result.message);
      } on OdidMessageParseError catch (e) {
        if (eagerFail) {
          rethrow;
        } else {
          warn(ParseWarning.severe(WarnMessages.failedToParseMessagePack(
              index: i, message: e.message)));
          continue;
        }
      }
    }

    // FIXME: Each message type can be present only once!

    return MessagePack(
      protocolVersion: protocolVersion,
      rawContent: _messageData,
      messages: messages,
    );
  }
}
