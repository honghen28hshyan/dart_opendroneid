import '../types.dart';
import '../constants.dart';
import 'odid_message_validator.dart';

class LocationMessageValidator implements ODIDMessageValidator {
  const LocationMessageValidator();

  @override
  bool validate(ODIDMessage message) =>
      message is LocationMessage ? _isLocationMessageValid(message) : false;

  bool _isLocationMessageValid(LocationMessage message) =>
      _isLocationValid(message) &&
      _isDirectionValid(message) &&
      _areSpeedsValid(message) &&
      _areAltitudesValid(message);

  bool _isLocationValid(LocationMessage message) =>
      message.location != null &&
      message.location!.latitude != invLat &&
      message.location!.longitude != invLon &&
      message.location!.latitude <= maxLat &&
      message.location!.longitude <= maxLon &&
      message.location!.latitude >= minLat &&
      message.location!.longitude >= minLon;

  // allow null dir, validate if not null
  bool _isDirectionValid(LocationMessage message) =>
      message.direction == null ||
      (message.direction! <= maxDir &&
          message.direction! >= minDir &&
          message.direction! != invDir);

  // allow null speeds, validate if not null
  bool _areSpeedsValid(LocationMessage message) {
    final verticalValid = message.verticalSpeed == null ||
        (message.verticalSpeed! <= maxSpeedV &&
            message.verticalSpeed! >= minSpeedV &&
            message.verticalSpeed! != invSpeedV);

    final horizontalValid = message.horizontalSpeed == null ||
        (message.horizontalSpeed! <= maxSpeedH &&
            message.horizontalSpeed! >= minSpeedH &&
            message.horizontalSpeed! != invSpeedH);

    return verticalValid && horizontalValid;
  }

  // allow null altitude, validate if not null
  bool _areAltitudesValid(LocationMessage message) {
    altValid(double? altitude) =>
        altitude == null ||
        (altitude <= maxAlt && altitude >= minAlt && altitude != invAlt);

    return altValid(message.altitudeGeodetic) &&
        altValid(message.altitudePressure);
  }
}
