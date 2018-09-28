import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openssl_flutter/openssl_flutter.dart';
import 'package:openssl_flutter/src/method_channel.dart';
import 'package:hex/hex.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _digest = 'Unknown';
  String _message = "test";
  String _password = "password";
  String _salt = "salt";
  String _derived = "Unknown";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    String digest;
    String derived;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await OpenSSLFlutterMethodChannel.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    try {
      final md = MessageDigest(DigestType.SHA512);
      digest = HEX.encode(await md.digest(_message));
    } on PlatformException {
      digest = "Failed to get digest for $_message";
    }

    try {
      final pbkdf2 = PBKDF2(DigestType.SHA512, 2048, 64);
      derived = HEX.encode(await pbkdf2.process(_password, _salt));
    } on PlatformException {
      _derived = "Failed to get deriviation";
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _digest = digest;
      _derived = derived;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Center(
            child: Column(
          children: <Widget>[
            Text('Running on: $_platformVersion\n'),
            Text(
              '$_message -> $_digest',
              softWrap: true,
            ),
            Text(
              '$_password x $_salt -> $_derived',
              softWrap: true,
            ),
          ],
        )),
      ),
    );
  }
}
