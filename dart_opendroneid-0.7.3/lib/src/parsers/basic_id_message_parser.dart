import 'dart:typed_data';

import '../enums.dart';
import '../constants.dart';
import '../decoders/basic_id_message_decoders.dart';
import '../decoders/decoders.dart';
import '../types/odid_message.dart';
import '../types/parse_warning.dart';
import '../types/uas_id.dart';
import 'odid_message_parser.dart';

class BasicIDMessageParser extends ODIDMessageParser<BasicIDMessage> {
  final Uint8List _messageData;
  BasicIDMessageParser(Uint8List messageData) : _messageData = messageData;

  @override
  BasicIDMessage parseImpl() {
    final protocolVersion =
        decodeField(decodeProtocolVersion, _messageData, 0, 1);

    // FIXME: validate protocol version here

    // UAS type is present on the lower 4 bits
    final uasTypeRaw = _messageData[1] & 0x0F;
    final uasType = UAType.getByValue(uasTypeRaw);

    if (uasType == null) {
      warn(ParseWarning(
          WarnMessages.unknownFieldValue('UAType', actualValue: uasTypeRaw)));
    }

    final uasID = decodeField(decodeUASID, _messageData, 1, 22);

    if (uasID == null) warn(ParseWarning(WarnMessages.unrecognizableUASID));

    return BasicIDMessage(
      protocolVersion: protocolVersion,
      rawContent: _messageData,
      uaType: uasType ?? UAType.other,
      uasID: uasID ?? IDNone(),
    );
  }
}
