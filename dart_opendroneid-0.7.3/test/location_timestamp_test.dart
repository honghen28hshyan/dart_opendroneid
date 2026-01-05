import 'package:dart_opendroneid/src/parsers/location_message_parser.dart';
import 'package:test/test.dart';

import 'resources/location_messages.dart';

void main() {
  test('correct utc timestamp handling', () {
    // Message has timestamp of 32.2s since last UTC hour
    final locationMessageRaw = LocationMessages.correctMessage;
    final locationMessage = LocationMessageParser(locationMessageRaw).parse();

    final timestampOffset = locationMessage.timestamp;
    expect(timestampOffset, isNotNull);

    final receivedOnLocal = DateTime(2023, 1, 1, 12, 30, 0, 0, 0);
    final receivedOnUtc = receivedOnLocal.toUtc();

    final receivedOnUtcHour = receivedOnUtc.roundToHour();

    final timestampUtc = locationMessage.getAbsoluteTimestamp(receivedOnUtc);

    expect(timestampUtc, isNotNull);
    expect(timestampUtc!.isUtc, isTrue);

    final utcDifference = timestampUtc.difference(receivedOnUtcHour);
    expect(utcDifference.inMilliseconds, equals(32200));
  });

  test('correct local timezone handling', () {
    // Message has timestamp of 32.2s since last UTC hour
    final locationMessageRaw = LocationMessages.correctMessage;
    final locationMessage = LocationMessageParser(locationMessageRaw).parse();

    final timestampOffset = locationMessage.timestamp;
    expect(timestampOffset, isNotNull);

    final receivedOnLocal = DateTime(2023, 1, 1, 12, 30, 0, 0, 0);
    final receivedOnLocalHour = receivedOnLocal.roundToHour();

    final timestampUtc = locationMessage.getAbsoluteTimestamp(receivedOnLocal);

    expect(timestampUtc, isNotNull);
    expect(timestampUtc!.isUtc, isTrue);

    final timestampLocal = timestampUtc.toLocal();

    final localDifference = timestampLocal.difference(receivedOnLocalHour);
    expect(localDifference.inMilliseconds, equals(32200));
  });
}

extension DateTimeRoundingExtension on DateTime {
  DateTime roundToHour() => copyWith(
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );
}
