import Flutter
import UIKit
import openssl
import os.log
    
public class SwiftOpensslFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "openssl_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftOpensslFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
        result("iOS " + UIDevice.current.systemVersion)
    case "getSha512Digest":
        let args = call.arguments as! [String:Any]
        result(getSha512Digest(args["source"] as! String))
    default:
        result("iOS " + UIDevice.current.systemVersion)
    }
  }
    
    func getSha512Digest(_ target: String) -> String {
        var ctxp = RIPEMD160_CTX()
        let data = target.cString(using: .utf8)
        var result = [UInt8](repeating: 0, count: Int(RIPEMD160_DIGEST_LENGTH))
        
        RIPEMD160_Init(&ctxp)
        RIPEMD160_Update(&ctxp, data, data!.count - 1)
        RIPEMD160_Final(&result, &ctxp)
        
        return result.hexa
    }
}

extension String {
    var hexaBytes: [UInt8] {
        var position = startIndex
        return (0..<count/2).compactMap { _ in
            defer { position = index(position, offsetBy: 2) }
            return UInt8(self[position...index(after: position)], radix: 16)
        }
    }
    var hexaData: Data { return hexaBytes.data }
}

extension Collection where Iterator.Element == UInt8 {
    var data: Data {
        return Data(self)
    }
    var hexa: String {
        return map{ String(format: "%02X", $0) }.joined()
    }
}
