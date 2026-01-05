import 'package:test/test.dart';
import 'package:dart_opendroneid/src/converters/timestamp_converter.dart';

void main() {
  group('convertOdidTimestamp', () {
    test('null timestamp returns null', () {
      final receiptTime = DateTime.utc(2025, 3, 12, 14, 30, 0);
      final result = convertOdidTimestamp(null, receiptTime: receiptTime);
      expect(result, isNull);
    });

    test('simple timestamp from current hour', () {
      final receiptTime = DateTime.utc(2025, 3, 12, 14, 30, 0); // 14:30:00
      final timestamp = const Duration(minutes: 25); // 25:00.0
      final decoded = convertOdidTimestamp(timestamp, receiptTime: receiptTime);
      expect(decoded, equals(DateTime.utc(2025, 3, 12, 14, 25, 0)));
    });

    test('simple timestamp from previous hour', () {
      final receiptTime = DateTime.utc(2025, 3, 12, 14, 10, 0); // 14:10:00
      final timestamp =
          const Duration(minutes: 50); // 50:00.0 (must be from previous hour)
      final decoded = convertOdidTimestamp(timestamp, receiptTime: receiptTime);
      expect(decoded, equals(DateTime.utc(2025, 3, 12, 13, 50, 0)));
    });

    test('exact hour boundary zero (XX:00:00.0)', () {
      final receiptTime = DateTime.utc(2025, 3, 12, 9, 10, 11);
      final timestamp = Duration.zero; // 00:00.0
      final decoded = convertOdidTimestamp(timestamp, receiptTime: receiptTime);
      expect(decoded, equals(DateTime.utc(2025, 3, 12, 9, 0, 0)));
    });

    test('exact hour boundary max (XX:59:59.9)', () {
      final receiptTime = DateTime.utc(2025, 3, 12, 15, 10, 0);
      final timestamp = const Duration(
          minutes: 59, seconds: 59, milliseconds: 900); // 59:59.9
      final decoded = convertOdidTimestamp(timestamp, receiptTime: receiptTime);
      expect(decoded, equals(DateTime.utc(2025, 3, 12, 14, 59, 59, 900)));
    });

    test('near hour boundary end', () {
      final receiptTime =
          DateTime.utc(2025, 3, 12, 15, 0, 1); // Just after hour change
      final timestamp = const Duration(
          minutes: 59,
          seconds: 59,
          milliseconds: 900); // 59:59.0 from previous hour
      final decoded = convertOdidTimestamp(timestamp, receiptTime: receiptTime);
      expect(decoded, equals(DateTime.utc(2025, 3, 12, 14, 59, 59, 900)));
    });

    test('near hour boundary start', () {
      final receiptTime =
          DateTime.utc(2025, 3, 12, 14, 59, 59, 900); // Just before hour change
      final timestamp = const Duration(seconds: 1); // 00:01.0 from current hour
      final decoded = convertOdidTimestamp(timestamp, receiptTime: receiptTime);
      expect(decoded, equals(DateTime.utc(2025, 3, 12, 14, 0, 1)));
    });

    test('near fractional seconds', () {
      final receiptTime = DateTime.utc(2025, 3, 12, 14, 30, 1);
      final timestamp =
          const Duration(minutes: 30, milliseconds: 500); // 30:00.5
      final decoded = convertOdidTimestamp(timestamp, receiptTime: receiptTime);
      expect(decoded, equals(DateTime.utc(2025, 3, 12, 14, 30, 0, 500)));
    });

    test('cross day boundary', () {
      final receiptTime =
          DateTime.utc(2025, 3, 13, 0, 5, 0); // 00:05:00 on March 13
      final timestamp = const Duration(
          minutes: 58, seconds: 20); // 58:20.0 (must be from previous hour)
      final decoded = convertOdidTimestamp(timestamp, receiptTime: receiptTime);
      expect(decoded, equals(DateTime.utc(2025, 3, 12, 23, 58, 20)));
    });

    test('receipt exactly matches timestamp', () {
      final receiptTime = DateTime.utc(2025, 3, 12, 14, 25, 26); // 14:25:26
      final timestamp = const Duration(minutes: 25, seconds: 26); // 25:26.0
      final decoded = convertOdidTimestamp(timestamp, receiptTime: receiptTime);
      expect(decoded, equals(DateTime.utc(2025, 3, 12, 14, 25, 26)));
    });

    test('maximum allowed duration in an hour', () {
      // Test with timestamp at max duration possible within an hour
      final receiptTime = DateTime.utc(2025, 3, 12, 14, 10, 0);
      final timestamp = const Duration(hours: 1) -
          const Duration(milliseconds: 1); // 59:59.999
      final decoded = convertOdidTimestamp(timestamp, receiptTime: receiptTime);
      expect(decoded, equals(DateTime.utc(2025, 3, 12, 13, 59, 59, 999)));
    });
  });
}
