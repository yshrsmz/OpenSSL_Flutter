import 'dart:async';

import 'package:flutter/services.dart';

class OpensslFlutter {
  static const MethodChannel _channel = const MethodChannel('openssl_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> getSha512Digest(String source) async {
    final String digest = await _channel
        .invokeMethod("getSha512Digest", <String, dynamic>{'source': source});
    return digest;
  }
}
