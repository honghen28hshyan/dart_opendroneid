import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_opendroneid/dart_opendroneid.dart';
import 'package:dart_opendroneid/src/decoders/decoders.dart';
import 'package:dart_opendroneid/src/encoders/generic_encoders.dart';
import 'package:dart_opendroneid/src/parsers/basic_id_message_parser.dart';
import 'package:dart_opendroneid/src/parsers/location_message_parser.dart';
import 'package:dart_opendroneid/src/parsers/operator_id_message_parser.dart';
import 'package:dart_opendroneid/src/parsers/self_id_message_parser.dart';
import 'package:dart_opendroneid/src/parsers/system_message_parser.dart';
import 'package:test/test.dart';

void main() {
  group('Generic Encoders Tests', () {
    test('encodeString handles an empty string correctly', () {
      var encoded = encodeString('', 5);
      expect(encoded, equals(List.filled(5, 0)));
      expect(decodeString(ByteData.sublistView(Uint8List.fromList(encoded))),
          equals(''));
    });

    test('encodeString handles strings shorter than the specified length', () {
      final shortResult = encodeString('test', 10);
      expect(shortResult.length, equals(10));
      expect(shortResult.sublist(0, 4), equals(utf8.encode('test')));
      expect(shortResult.sublist(4), equals(List.filled(6, 0)));
      expect(
          decodeString(ByteData.sublistView(Uint8List.fromList(shortResult))),
          equals('test'));
    });

    test('encodeString handles strings exactly matching the specified length',
        () {
      final exactResult = encodeString('test', 4);
      expect(exactResult.length, equals(4));
      expect(exactResult, equals(utf8.encode('test')));
      expect(
          decodeString(ByteData.sublistView(Uint8List.fromList(exactResult))),
          equals('test'));
    });

    test('encodeString handles strings with special characters', () {
      final specialChars = encodeString('test@123', 10);
      expect(specialChars.length, equals(10));
      expect(specialChars.sublist(0, 8), equals(utf8.encode('test@123')));
      expect(
          decodeString(ByteData.sublistView(Uint8List.fromList(specialChars))),
          equals('test@123'));
    });

    test('encodeCoordinate correctly encodes and decodes coordinates', () {
      final coordinates = [
        50.0755, // Prague latitude
        14.4378, // Prague longitude
        -33.8688, // Sydney latitude
        151.2093, // Sydney longitude
      ];

      for (final coordinate in coordinates) {
        final encoded = encodeCoordinate(coordinate);
        final decoded = decodeCoordinate(encoded);
        expect(decoded, closeTo(coordinate, 0.0001),
            reason: 'Failed to encode/decode coordinate: $coordinate');
      }
    });

    test('encodeAltitude correctly encodes and decodes altitude', () {
      final altitudes = [100.0, -100.0, 0.0, 1000.0];

      for (final altitude in altitudes) {
        final encoded = encodeAltitude(altitude);
        final decoded = decodeAltitude(encoded);
        expect(decoded, closeTo(altitude, 0.5),
            reason: 'Failed to encode/decode altitude: $altitude');
      }
    });
  });

  group('ID Message Encoders Tests', () {
    test('encodeSelfIDMessage correctly encodes and can be parsed', () {
      final description = 'Test Drone';
      final encoded = encodeSelfIDMessage(description);

      final parser = SelfIDMessageParser(Uint8List.fromList(encoded));
      final decoded = parser.parse();

      expect(parser.hasWarnings, isFalse);
      expect(decoded.description, equals(description));
      expect(decoded.descriptionType, isA<DescriptionTypeText>());
    });

    test('encodeBasicIDMessage correctly encodes and can be parsed', () {
      final serialNumber = 'DR123456789';
      final encoded = encodeBasicIDMessage(UAType.gyroplane, serialNumber);

      final parser = BasicIDMessageParser(Uint8List.fromList(encoded));
      final decoded = parser.parse();

      expect(parser.hasWarnings, isFalse);
      expect(decoded.uaType, equals(UAType.gyroplane));
      expect(
          (decoded.uasID as SerialNumber).serialNumber, equals(serialNumber));
    });

    test('encodeOperatorIdMessage correctly encodes and can be parsed', () {
      final operatorId = 'TEST123456789';
      final encoded = encodeOperatorIdMessage(operatorId);

      final parser = OperatorIDMessageParser(Uint8List.fromList(encoded));
      final decoded = parser.parse();

      expect(parser.hasWarnings, isFalse);
      expect(decoded.operatorID, equals(operatorId));
      expect(decoded.operatorIDType, isA<OperatorIDTypeOperatorID>());
    });
  });

  group('Location Message Encoders Tests', () {
    test('encodeLocationMessage correctly encodes and can be parsed', () {
      final location = Location(latitude: 55.751244, longitude: 37.618423);
      final encoded = encodeLocationMessage(
        location: location,
        altitudePressure: 100,
        altitudeGeodetic: 110,
        height: 50,
        verticalSpeed: 2.5,
        horizontalSpeed: 5.0,
        direction: 90,
        timestamp: const Duration(seconds: 30),
      );

      final parser = LocationMessageParser(Uint8List.fromList(encoded));
      final decoded = parser.parse();

      expect(parser.hasWarnings, isFalse);
      expect(decoded.location?.latitude, closeTo(location.latitude, 0.0001));
      expect(decoded.location?.longitude, closeTo(location.longitude, 0.0001));
      expect(decoded.altitudePressure, closeTo(100, 0.5));
      expect(decoded.altitudeGeodetic, closeTo(110, 0.5));
      expect(decoded.height, closeTo(50, 0.5));
      expect(decoded.verticalSpeed, closeTo(2.5, 0.1));
      expect(decoded.horizontalSpeed, closeTo(5.0, 0.25));
      expect(decoded.direction, equals(90));
      // FIXME (timestamp): Fix timestamp encoding/decoding mismatch
      expect(decoded.timestamp?.inSeconds, equals(30));
    });
  });

  group('System Message Encoders Tests', () {
    test('encodeSystemMessage correctly encodes and can be parsed', () {
      final operatorLocation =
          Location(latitude: 55.751244, longitude: 37.618423);
      final encoded = encodeSystemMessage(
        operatorLocation: operatorLocation,
        operatorAltitude: 100,
        areaCount: 1,
        areaRadius: 500,
        areaCeiling: 120,
        areaFloor: 0,
      );

      final parser = SystemMessageParser(Uint8List.fromList(encoded));
      final decoded = parser.parse();

      expect(parser.hasWarnings, isFalse);
      expect(decoded.operatorLocation?.latitude,
          closeTo(operatorLocation.latitude, 0.0001));
      expect(decoded.operatorLocation?.longitude,
          closeTo(operatorLocation.longitude, 0.0001));
      expect(decoded.operatorAltitude, closeTo(100, 0.5));
      expect(decoded.areaCount, equals(1));
      expect(decoded.areaRadius, equals(500));
      expect(decoded.areaCeiling, closeTo(120, 0.5));
      expect(decoded.areaFloor, closeTo(0, 0.5));
      expect(
          decoded.operatorLocationType, equals(OperatorLocationType.takeOff));
      expect(decoded.uaClassification, isA<UAClassificationEurope>());
    });
  });
}
