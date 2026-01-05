import 'dart:typed_data';

import '../constants.dart';
import '../decoders/decoders.dart';
import '../types/odid_message.dart';
import '../types/description_type.dart';
import '../types/parse_warning.dart';
import 'odid_message_parser.dart';

class SelfIDMessageParser extends ODIDMessageParser<SelfIDMessage> {
  final Uint8List _messageData;
  SelfIDMessageParser(Uint8List messageData) : _messageData = messageData;

  @override
  SelfIDMessage parseImpl() {
    final protocolVersion =
        decodeField(decodeProtocolVersion, _messageData, 0, 1);

    // FIXME: validate protocol version here

    final descriptionType =
        decodeField(decodeDescriptionType, _messageData, 1, 2);
    final description = decodeField(decodeString, _messageData, 2, 25);

    if (descriptionType == null) {
      warn(ParseWarning(WarnMessages.unknownFieldValue('DescriptionType')));
    }

    return SelfIDMessage(
      protocolVersion: protocolVersion,
      rawContent: _messageData,
      descriptionType: descriptionType ?? DescriptionTypeText(),
      description: description,
    );
  }
}
