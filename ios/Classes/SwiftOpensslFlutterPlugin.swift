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
    case "getDigest":
        let args = call.arguments as! [String: Any]
        result(getDigest(digestType: args["type"] as! String, message: args["message"] as! String))
    default:
        result("iOS " + UIDevice.current.systemVersion)
    }
  }
    
    func getDigest(digestType: String, message: String) -> FlutterStandardTypedData {
        let type = digestType.cString(using: .utf8)
        let data = message.cString(using: .utf8)
        var result = [UInt8](repeating: 0, count: Int(EVP_MAX_MD_SIZE))
        var md_len: UInt32 = 0
        
        let ctx = EVP_MD_CTX_new()
        let md = EVP_get_digestbyname(type)
        EVP_DigestInit_ex(ctx, md, nil)
        EVP_DigestUpdate(ctx, data, data!.count - 1)
        EVP_DigestFinal_ex(ctx, &result, &md_len)
        EVP_MD_CTX_free(ctx)
        
        let actual = FlutterStandardTypedData(bytes: Data(bytes: Array(result[0..<Int(md_len)])))
        
        return actual;
    }

    func getRIPEMD160(_ target: String) -> String {
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
