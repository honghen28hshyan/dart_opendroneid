import 'dart:typed_data';

typedef FieldEncoder<T> = ByteData Function(T);

List<int> encodeField<T>(FieldEncoder<T> encoder, T input) =>
    encoder(input).buffer.asInt8List();

List<int> mergeFieldsToMessage(List<List<int>> fields) =>
    fields.expand<int>((byte) => byte).toList();
