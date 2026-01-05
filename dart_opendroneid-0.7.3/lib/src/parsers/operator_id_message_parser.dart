import 'dart:typed_data';

import 'package:dart_opendroneid/src/constants.dart';

import '../decoders/decoders.dart';
import '../types/odid_message.dart';
import '../types/operator_id_type.dart';
import '../types/parse_warning.dart';
import 'odid_message_parser.dart';

class OperatorIDMessageParser extends ODIDMessageParser<OperatorIDMessage> {
  final Uint8List _messageData;
  OperatorIDMessageParser(Uint8List messageData) : _messageData = messageData;

  @override
  OperatorIDMessage parseImpl() {
    final protocolVersion =
        decodeField(decodeProtocolVersion, _messageData, 0, 1);

    // FIXME: validate protocol version here

    final operatorIDType =
        decodeField(decodeOperatorIDType, _messageData, 1, 2);
    final operatorID = decodeField(decodeString, _messageData, 2, 22);

    if (operatorIDType == null) {
      warn(ParseWarning(WarnMessages.unknownFieldValue('OperatorIDType')));
    }

    return OperatorIDMessage(
      protocolVersion: protocolVersion,
      rawContent: _messageData,
      operatorIDType:
          operatorIDType ?? OperatorIDTypeOperatorID(), // TODO: feels incorrect
      operatorID: operatorID,
    );
  }
}
