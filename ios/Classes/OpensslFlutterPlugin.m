#import "OpensslFlutterPlugin.h"
#import <openssl_flutter/openssl_flutter-Swift.h>

@implementation OpensslFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftOpensslFlutterPlugin registerWithRegistrar:registrar];
}
@end
