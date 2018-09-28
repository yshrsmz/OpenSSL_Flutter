import 'dart:typed_data';
import 'dart:async';
import 'package:openssl_flutter/src/message_digest.dart';
import 'package:openssl_flutter/src/method_channel.dart';
import 'package:openssl_flutter/src/util.dart';

class PBKDF2 {
  final DigestType digestType;
  final int iteration;
  final int keyLength;

  PBKDF2(this.digestType, this.iteration, this.keyLength);

  Future<Uint8List> process(String password, String salt) {
    final type = enumEntryName(digestType);
    return OpenSSLFlutterMethodChannel.getPBKDF2withHMAC(password, salt, type, iteration, keyLength);
  }
}
