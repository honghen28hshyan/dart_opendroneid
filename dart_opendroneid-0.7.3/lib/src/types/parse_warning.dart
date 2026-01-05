class ParseWarning {
  final String message;
  final bool isSevere;
  final int? offset;

  const ParseWarning(
    this.message, {
    this.isSevere = false,
    this.offset,
  });

  factory ParseWarning.severe(
    String message, {
    int? offset,
  }) {
    return ParseWarning(
      message,
      isSevere: true,
      offset: offset,
    );
  }

  @override
  String toString() {
    final offsetStr = offset != null ? ' (at offset $offset)' : '';
    return 'ParseWarning {$message$offsetStr, isSevere: $isSevere}';
  }
}
