import '../types.dart';
import '../constants.dart';
import 'odid_message_validator.dart';

class OperatorIDMessageValidator implements ODIDMessageValidator {
  const OperatorIDMessageValidator();

  @override
  bool validate(ODIDMessage message) => message is OperatorIDMessage
      ? _isOperatorIDSet(message) && _isOperatorIDValid(message)
      : false;

  bool _isOperatorIDSet(OperatorIDMessage message) =>
      message.operatorID != operatorIdNotSet;

  bool _isOperatorIDValid(OperatorIDMessage message) {
    final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
    return message.operatorID.length == 16 &&
        validCharacters.hasMatch(message.operatorID);
  }
}
