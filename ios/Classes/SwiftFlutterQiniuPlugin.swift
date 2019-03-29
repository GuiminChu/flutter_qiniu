import Flutter
import UIKit
import Qiniu

public class SwiftFlutterQiniuPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_qiniu", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterQiniuPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print(call.arguments)
        print(call.method)
    
        if call.method == "getPlatformVersion" {
            result("iOS " + UIDevice.current.systemVersion)
        } else if call.method == "upload" {
            upload(arguments: call.arguments, result: result)
        } else if call.method == "uploadData" {
            uploadData(arguments: call.arguments, result: result)
        }
    }
    
    func upload(arguments: Any?, result: @escaping FlutterResult) {
        guard let arguments = arguments as? [String: String],
            let filePath = arguments["filePath"],
            let key = arguments["key"],
            let token = arguments["token"] else {
                result(false)
                return
        }
    
        let config = QNConfiguration.build { builder in
            // 设置区域，默认华东
            let zoneRaw = arguments["zone"] ?? "0"
            builder?.setZone(self.getZone(raw: zoneRaw))
        }

        let uploadManager = QNUploadManager(configuration: config)

        uploadManager?.putFile(filePath, key: key, token: token, complete: { (responseInfo, key, dict) in
            print("上传结果：")
            print(dict)
            if dict == nil {
                result(false)
            } else {
                result(true)
            }
        }, option: nil)
    }
    
    func uploadData(arguments: Any?, result: @escaping FlutterResult) {
        guard let arguments = arguments as? [String: Any],
            let flutterData = arguments["data"] as? FlutterStandardTypedData,
            let key = arguments["key"] as? String,
            let token = arguments["token"] as? String else {
                result(false)
                return
        }
        
        let config = QNConfiguration.build { builder in
            // 设置区域，默认华东
            let zoneRaw = arguments["zone"] as? String ?? "0"
            builder?.setZone(self.getZone(raw: zoneRaw))
        }
        
        let uploadManager = QNUploadManager(configuration: config)
        
        uploadManager?.put(flutterData.data, key: key, token: token, complete: { (responseInfo, key, dict) in
            print("上传结果：")
            print(dict)
            if dict == nil {
                result(false)
            } else {
                result(true)
            }
        }, option: nil)
    }
    
    private func getZone(raw: String) -> QNFixedZone? {
        var zone: QNFixedZone?
        
        switch raw {
        case "0":
            zone = QNFixedZone.zone0()
        case "1":
            zone = QNFixedZone.zone1()
        case "2":
            zone = QNFixedZone.zone2()
        case "3":
            zone = QNFixedZone.zoneNa0()
        case "4":
            zone = QNFixedZone.zoneAs0()
        default:
            zone = QNFixedZone.zone0()
        }
        
        return zone
    }
}
