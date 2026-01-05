const maxMessageSize = 25;
const maxIDByteSize = 20;
const maxStringByteSize = 23;
const maxAuthDataPages = 16;
const maxAuthPageZeroSize = 17;
const maxAuthPageNonZeroSize = 23;
const maxAuthData =
    maxAuthPageZeroSize + (maxAuthDataPages - 1) * maxAuthPageNonZeroSize;
const maxMessagesInPack = 9;
const maxMessagePackSize = maxMessageSize * maxMessagesInPack;
const latLonMultiplier = 1e-7;
const verticalSpeedMultiplier = 0.5;
const areaRadiusMultiplier = 10;
const odidEpochOffset = 1546300800;
const minDir = 0;
const maxDir = 360;
const invDir = 361;
const minSpeedH = 0;
const maxSpeedH = 254.25;
const invSpeedH = 255;
const minSpeedV = (-62);
const maxSpeedV = 62;
const invSpeedV = 63;
const minLat = -90;
const maxLat = 90;
const invLat = 0;
const minLon = -180;
const maxLon = 180;
const invLon = 0;
const minAlt = (-1000);
const maxAlt = 31767.5;
const invAlt = minAlt;
const maxAreaRadius = 2550;
const operatorIdNotSet = 'NULL';

class WarnMessages {
  static String unknownFieldValue(
    String fieldName, {
    dynamic actualValue,
  }) =>
      ('Unknown value for $fieldName ${actualValue ?? ''}');

  static const String authenticationMessageExceedsMaxSizes =
      ('Authentication message exceeds maximum sizes');

  static const String unrecognizableUASID =
      ('Unrecognizable UAS ID (or IDType)');

  static const String unknownHeightTypeHeightIgnored =
      ('Unknown HeightType, height value ignored');

  static String failedToParseMessagePack({
    required int index,
    required String message,
  }) =>
      ('Failed to parse message pack at index $index: $message');

  static const String timestampContainsInvalidDate =
      ('Timestamp contains invalid date, using current time instead');
}
