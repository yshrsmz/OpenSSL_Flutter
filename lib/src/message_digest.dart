import 'dart:typed_data';
import 'dart:async';
import 'package:openssl_flutter/src/method_channel.dart';
import 'package:openssl_flutter/src/util.dart';

enum DigestType {
  SHA256,
  SHA512
}

class MessageDigest {
  final DigestType type;

  MessageDigest(this.type);

  /// Returns Digest for provided [message]
  Future<Uint8List> digest(String message) {
    return OpenSSLFlutterMethodChannel.getDigest(enumEntryName(type), message);
  }
}
