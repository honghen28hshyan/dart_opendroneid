import 'dart:convert';
import 'dart:typed_data';

import '../constants.dart';
import '../types.dart';

const protocolVersion = 2;

List<int> encodeString(String input, int len) {
  assert(input.length <= len);
  return utf8.encode(input.padRight(len, '\u0000'));
}

ByteData encodeFirstByte(MessageType messageType) {
  final value = (messageType.value << 4) + protocolVersion;

  return ByteData(1)..setInt8(0, value.toInt());
}

ByteData encodeCoordinate(double input) {
  final value = input / latLonMultiplier;

  return ByteData(4)..setInt32(0, value.toInt(), Endian.little);
}

ByteData encodeAltitude(double altitude) {
  final value = (altitude + 1000) / 0.5;
  return ByteData(2)..setInt16(0, value.toInt(), Endian.little);
}

ByteData encodeODIDEpochTimestamp(DateTime input) {
  final value = input.toUtc().millisecondsSinceEpoch / 1000 - odidEpochOffset;

  return ByteData(4)..setInt32(0, value.toInt(), Endian.little);
}
