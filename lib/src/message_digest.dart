import 'dart:typed_data';

enum DigestType {
  SHA256,
  SHA512
}

class MessageDigest {
  final DigestType type;

  MessageDigest(this.type);

  /// Returns Digest for provided [message]
  Uint8List digest(String message) {
    return Uint8List(0);
  }
}
