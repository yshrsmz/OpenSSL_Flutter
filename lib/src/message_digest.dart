import 'dart:typed_data';
import 'dart:async';
import 'package:openssl_flutter/src/method_channel.dart';

enum DigestType {
  SHA256,
  SHA512
}

class MessageDigest {
  final DigestType type;

  MessageDigest(this.type);

  /// Returns Digest for provided [message]
  Future<Uint8List> digest(String message) {
    return OpenSSLFlutterMethodChannel.getDigest(this._typeAsString, message);
  }

  String get _typeAsString {
    switch (this.type) {
      case DigestType.SHA256: return "SHA256";
      case DigestType.SHA512: return "SHA512";
      default: throw ArgumentError.value(this.type);
    }
  }
}
