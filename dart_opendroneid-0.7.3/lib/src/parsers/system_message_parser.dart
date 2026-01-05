import 'dart:typed_data';

import '../constants.dart';
import '../decoders/decoders.dart';
import '../types.dart';
import 'odid_message_parser.dart';

class SystemMessageParser extends ODIDMessageParser<SystemMessage> {
  final Uint8List _messageData;
  SystemMessageParser(Uint8List messageData) : _messageData = messageData;

  @override
  SystemMessage parseImpl() {
    final protocolVersion =
        decodeField(decodeProtocolVersion, _messageData, 0, 1);

    final operatorLocationTypeRaw = _messageData[1] & 0x03;
    final operatorLocationType =
        OperatorLocationType.getByValue(operatorLocationTypeRaw);
    final operatorLocation = decodeField(decodeLocation, _messageData, 2, 10);
    final operatorAltitude = decodeField(decodeAltitude, _messageData, 18, 20);
    final areaCount = decodeField(decodeAreaCount, _messageData, 10, 12);
    final areaRadius = decodeField(decodeAreaRadius, _messageData, 12, 13);
    final areaCeiling = decodeField(decodeAltitude, _messageData, 13, 15);
    final areaFloor = decodeField(decodeAltitude, _messageData, 15, 17);

    // Flags needed, 1st byte included in passed data
    final uaClassification =
        decodeField(decodeUAClassification, _messageData, 1, 18);
    var timestamp = decodeField(decodeODIDEpochTimestamp, _messageData, 20, 24);

    if (operatorLocationType == null) {
      warn(ParseWarning(WarnMessages.unknownFieldValue('OperatorLocationType',
          actualValue: operatorLocationTypeRaw)));
    }

    if (uaClassification == null) {
      warn(ParseWarning(WarnMessages.unknownFieldValue('UAClassification')));
    }

    if (timestamp ==
        DateTime.fromMillisecondsSinceEpoch(odidEpochOffset * 1000)) {
      warn(ParseWarning(WarnMessages.timestampContainsInvalidDate));
      timestamp = DateTime.now().toUtc();
    }

    return SystemMessage(
      protocolVersion: protocolVersion,
      rawContent: _messageData,
      operatorLocationType: operatorLocationType ?? OperatorLocationType.fixed,
      operatorLocation: operatorLocation,
      operatorAltitude: operatorAltitude,
      areaCount: areaCount,
      areaRadius: areaRadius,
      areaCeiling: areaCeiling,
      areaFloor: areaFloor,
      uaClassification: uaClassification ?? UAClassificationUndeclared(),
      timestamp: timestamp,
    );
  }
}
