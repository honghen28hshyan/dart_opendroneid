import '../types.dart';
import 'field_encoders.dart';
import 'generic_encoders.dart';
import 'location_message_encoders.dart';
import 'system_message_encoders.dart';

List<int> encodeSelfIDMessage(String description) => mergeFieldsToMessage([
      encodeField(encodeFirstByte, MessageType.selfID),
      [const DescriptionTypeText().value],
      encodeString(description, 23)
    ]);

List<int> encodeBasicIDMessage(UAType uaType, String serialNumber) {
  // second byte contains types
  final secondByte = (IDType.serialNumber.value << 4) + uaType.value;
  return mergeFieldsToMessage([
    encodeField(encodeFirstByte, MessageType.basicID),
    [secondByte],
    encodeString(serialNumber, 23),
  ]);
}

List<int> encodeOperatorIdMessage(String operatorId) => mergeFieldsToMessage([
      encodeField(encodeFirstByte, MessageType.operatorID),
      [OperatorIDTypeOperatorID().value],
      encodeString(operatorId, 23),
    ]);

List<int> encodeLocationMessage({
  required Location location,
  required double altitudePressure,
  required double altitudeGeodetic,
  required double height,
  required double verticalSpeed,
  required double horizontalSpeed,
  required int direction,
  required Duration timestamp,
}) {
  // second byte contains flags
  final eastWestBit = direction < 180 ? 0 : 1;
  final secondByte = (OperationalStatus.airborne.value << 4) +
      (HeightType.aboveGroundLevel.value << 2) +
      (eastWestBit << 1);

  final locationAccuracyByte = (VerticalAccuracy.meters_1.value << 4) +
      HorizontalAccuracy.meters_1.value;
  final baroAndSpeedAccuracyByte = (VerticalAccuracy.meters_1.value << 4) +
      SpeedAccuracy.meterPerSecond_1.value;

  return mergeFieldsToMessage([
    encodeField(encodeFirstByte, MessageType.location),
    [secondByte],
    encodeField(encodeDirection, direction),
    encodeField(encodeHorizontalSpeed, horizontalSpeed),
    encodeField(encodeVerticalSpeed, verticalSpeed),
    encodeField(encodeCoordinate, location.latitude),
    encodeField(encodeCoordinate, location.longitude),
    encodeField(encodeAltitude, altitudePressure),
    encodeField(encodeAltitude, altitudeGeodetic),
    encodeField(encodeAltitude, height),
    [locationAccuracyByte, baroAndSpeedAccuracyByte],
    encodeField(
      encodeLocationTimestamp,
      timestamp,
    ),
    encodeField(encodeTimestampAccuracy, const Duration(milliseconds: 500)),
    [0x00], // filler byte
  ]);
}

List<int> encodeSystemMessage({
  required Location operatorLocation,
  required double operatorAltitude,
  required int areaCount,
  required int areaRadius,
  required double areaCeiling,
  required double areaFloor,
}) {
  // second byte also contains UA classification flag
  final secondByte = (ClassificationType.europeanUnion.value << 2) +
      OperatorLocationType.takeOff.value;

  return mergeFieldsToMessage([
    encodeField(encodeFirstByte, MessageType.system),
    [secondByte],
    encodeField(encodeCoordinate, operatorLocation.latitude),
    encodeField(encodeCoordinate, operatorLocation.longitude),
    encodeField(encodeAreaCount, areaCount),
    encodeField(encodeAreaRadius, areaRadius),
    encodeField(encodeAltitude, areaCeiling),
    encodeField(encodeAltitude, areaFloor),
    encodeField(
        encodeEUClassification,
        const UAClassificationEurope(
            uaCategoryEurope: UACategoryEurope.EUOpen,
            uaClassEurope: UAClassEurope.EUClass_0)),
    encodeField(encodeAltitude, operatorAltitude),
    encodeField(encodeODIDEpochTimestamp, DateTime.now()),
    [0x00], // filler byte
  ]);
}
