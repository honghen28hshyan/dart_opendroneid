import '../types.dart';

abstract class ODIDMessageValidator {
  bool validate(ODIDMessage message);
}
