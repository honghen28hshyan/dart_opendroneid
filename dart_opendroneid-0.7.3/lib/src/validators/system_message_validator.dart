import '../types.dart';
import '../constants.dart';
import 'odid_message_validator.dart';

class SystemMessageValidator implements ODIDMessageValidator {
  const SystemMessageValidator();

  @override
  bool validate(ODIDMessage message) =>
      message is SystemMessage ? _isSystemMessageValid(message) : false;

  bool _isSystemMessageValid(SystemMessage message) =>
      _isOperatorLocationValid(message) &&
      _isOperatorAltitudeValid(message) &&
      message.areaRadius <= maxAreaRadius;

  bool _isOperatorLocationValid(SystemMessage message) =>
      message.operatorLocation != null &&
      message.operatorLocation!.latitude != invLat &&
      message.operatorLocation!.longitude != invLon &&
      message.operatorLocation!.latitude <= maxLat &&
      message.operatorLocation!.latitude >= minLat &&
      message.operatorLocation!.longitude <= maxLon &&
      message.operatorLocation!.longitude >= minLon;

  // allow null altitude, validate if not null
  bool _isOperatorAltitudeValid(SystemMessage message) =>
      message.operatorAltitude == null ||
      (message.operatorAltitude! != invAlt &&
          message.operatorAltitude! >= minAlt &&
          message.operatorAltitude! <= maxAlt);
}
