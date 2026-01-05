import 'dart:typed_data';

import '../enums.dart';
import '../constants.dart';
import '../decoders/decoders.dart';
import '../types/odid_message.dart';
import '../types/parse_warning.dart';
import 'odid_message_parser.dart';

class LocationMessageParser extends ODIDMessageParser<LocationMessage> {
  final Uint8List _messageData;
  LocationMessageParser(Uint8List messageData) : _messageData = messageData;

  @override
  LocationMessage parseImpl() {
    final protocolVersion =
        decodeField(decodeProtocolVersion, _messageData, 0, 1);

    // FIXME: validate protocol version here

    final statusValueRaw = (_messageData[1] & 0xF0) >> 4;
    final status = OperationalStatus.getByValue(statusValueRaw);
    final heightType = HeightType.getByValue((_messageData[1] & 0x04) >> 2);
    final direction = decodeField(decodeDirection, _messageData, 1, 3);

    // Flags needed, 1st byte included in passed data
    final horizontalSpeed =
        decodeField(decodeHorizontalSpeed, _messageData, 1, 4);
    final verticalSpeed = decodeField(decodeVerticalSpeed, _messageData, 4, 5);
    final location = decodeField(decodeLocation, _messageData, 5, 13);

    final altitudePressure = decodeField(decodeAltitude, _messageData, 13, 15);
    final altitudeGeodetic = decodeField(decodeAltitude, _messageData, 15, 17);
    final height = decodeField(decodeAltitude, _messageData, 17, 19);
    final verticalAccuracy =
        VerticalAccuracy.getByValue((_messageData[19] & 0xF0) >> 4);
    final horizontalAccuracy =
        HorizontalAccuracy.getByValue(_messageData[19] & 0x0F);
    final baroAltitudeAccuracy =
        BaroAltitudeAccuracy.getByValue((_messageData[20] & 0xF0) >> 4);
    // FIXME falling back to unknown if reserved values are used
    final speedAccuracy = SpeedAccuracy.getByValue(_messageData[20] & 0x0F) ??
        SpeedAccuracy.unknown;
    final timestamp =
        decodeField(decodeLocationTimestamp, _messageData, 21, 23);
    final timestampAccuracy =
        decodeField(decodeTimestampAccuracy, _messageData, 23, 24);

    if (status == null) {
      warn(ParseWarning(WarnMessages.unknownFieldValue('OperationalStatus',
          actualValue: statusValueRaw)));
    }

    if (heightType == null) {
      warn(ParseWarning(WarnMessages.unknownHeightTypeHeightIgnored));
    }

    return LocationMessage(
      protocolVersion: protocolVersion,
      rawContent: _messageData,
      status: status ?? OperationalStatus.none,
      heightType: heightType ?? HeightType.aboveTakeoff,
      direction: direction,
      horizontalSpeed: horizontalSpeed,
      verticalSpeed: verticalSpeed,
      location: location,
      altitudePressure: altitudePressure,
      altitudeGeodetic: altitudeGeodetic,
      height: heightType != null
          ? height
          : null, // Height without type shouldn't be propagated
      verticalAccuracy: verticalAccuracy ?? VerticalAccuracy.unknown,
      horizontalAccuracy: horizontalAccuracy ?? HorizontalAccuracy.unknown,
      baroAltitudeAccuracy:
          baroAltitudeAccuracy ?? BaroAltitudeAccuracy.unknown,
      speedAccuracy: speedAccuracy,
      timestamp: timestamp,
      timestampAccuracy: timestampAccuracy,
    );
  }
}
