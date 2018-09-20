import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class OpenSSLFlutterMethodChannel {
  static const MethodChannel _channel = const MethodChannel('openssl_flutter');

  OpenSSLFlutterMethodChannel._();

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> getSha512Digest(String source) async {
    final String digest = await _channel
        .invokeMethod("getSha512Digest", <String, dynamic>{'source': source});
    return digest;
  }

  static Future<Uint8List> getDigest(String digestType, String message) async {
    final args = <String, dynamic>{
      'type': digestType,
      'message': message
    };
    return await _channel.invokeMethod("getDigest", args);
  }
}
