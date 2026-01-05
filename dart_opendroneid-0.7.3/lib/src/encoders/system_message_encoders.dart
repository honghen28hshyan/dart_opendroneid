import 'dart:typed_data';

import '../constants.dart';
import '../types.dart';

ByteData encodeAreaCount(int input) {
  return ByteData(2)..setInt16(0, input, Endian.little);
}

ByteData encodeAreaRadius(int input) {
  final value = input / areaRadiusMultiplier;

  return ByteData(1)..setInt8(0, value.toInt());
}

ByteData encodeEUClassification(UAClassificationEurope classification) {
  final value = (classification.uaCategoryEurope.value << 4) +
      classification.uaClassEurope.value;
  return ByteData(1)..setInt8(0, value.toInt());
}
