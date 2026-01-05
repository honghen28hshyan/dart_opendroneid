extension _DateTimeWholeHour on DateTime {
  DateTime get wholeHourUtc => DateTime.utc(year, month, day, hour);
}

/// Converts previously decoded [timestamp] value into an absolute
/// [DateTime] according to the [receiptTime].
///
/// Implemented according to the ASTM F3411-22a Table 7:
///  > if Encoded Value > Tenths of seconds since the current hour at time of receipt,
///  > then
///  >   ValueTenths = tenths of seconds since previous hour
///  > else
///  >   ValueTenths = tenths of seconds since current hour
///  > Value = Current UTC Date/Time (Hour) + ValueTenths (of seconds)
///
/// Returns DateTime representing the absolute time, or null if timestamp is null
DateTime? convertOdidTimestamp(
  Duration? timestamp, {
  required DateTime receiptTime,
}) {
  if (timestamp == null) return null;

  var baseTime = receiptTime.toUtc().wholeHourUtc;
  final elapsedSinceCurrentHour = receiptTime.difference(baseTime);

  if (timestamp > elapsedSinceCurrentHour) {
    baseTime = baseTime.subtract(Duration(hours: 1));
  }

  return baseTime.add(timestamp);
}
