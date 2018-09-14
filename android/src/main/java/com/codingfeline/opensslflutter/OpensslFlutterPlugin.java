package com.codingfeline.opensslflutter;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** OpensslFlutterPlugin */
public class OpensslFlutterPlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "openssl_flutter");
    channel.setMethodCallHandler(new OpensslFlutterPlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    switch (call.method) {
      case "getPlatformVersion":
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      case "getSha512Digest":
        result.success(getSha512Digest(call.<String>argument("source")));
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  public native String getSha512Digest(String target);

  static {
    System.loadLibrary("crypto-main");
  }
}
