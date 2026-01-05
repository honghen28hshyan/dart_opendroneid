import 'dart:typed_data';

import '../constants.dart';

ByteData encodeDirection(int input) {
  return ByteData(1)..setInt8(0, input);
}

ByteData encodeHorizontalSpeed(double speed) {
  final value = (speed) / 0.25;

  return ByteData(1)..setInt8(0, value.toInt());
}

ByteData encodeVerticalSpeed(double input) {
  final value = input / verticalSpeedMultiplier;

  return ByteData(1)..setInt8(0, value.toInt());
}

ByteData encodeLocationTimestamp(Duration timeSinceLastFullHour) {
  final value = timeSinceLastFullHour.inMilliseconds / 100;
  return ByteData(2)..setInt16(0, value.toInt(), Endian.little);
}

ByteData encodeTimestampAccuracy(Duration input) {
  final value = input.inMilliseconds / 100;

  return ByteData(1)..setInt8(0, value.toInt());
}
