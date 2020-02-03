import Flutter
import UIKit
import Qiniu

enum FlutterChannel: String {
    static let methodChannelName = "flutter_qiniu_method"
    static let eventChannelName = "flutter_qiniu_event"
    
    case uploadFile
    case uploadData
}

public class SwiftFlutterQiniuPlugin: NSObject, FlutterPlugin {
    var eventSink: FlutterEventSink?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: FlutterChannel.methodChannelName, binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterQiniuPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        
        let eventChannel = FlutterEventChannel.init(name: FlutterChannel.eventChannelName, binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == FlutterChannel.uploadFile.rawValue {
            uploadFile(arguments: call.arguments, result: result)
        } else if call.method == FlutterChannel.uploadData.rawValue {
            uploadData(arguments: call.arguments, result: result)
        }
    }
    
    func uploadFile(arguments: Any?, result: @escaping FlutterResult) {
        guard let arguments = arguments as? [String: String],
            let filePath = arguments["filePath"],
            let key = arguments["key"],
            let token = arguments["token"] else {
                result("")
                return
        }
        
        let config = QNConfiguration.build { builder in
            // 设置区域，默认华东
            let zoneRaw = arguments["zone"] ?? "0"
            builder?.setZone(self.getZone(raw: zoneRaw))
        }
        
        let uploadManager = QNUploadManager(configuration: config)
        
        let option = QNUploadOption(mime: nil, progressHandler: { (key, percent) in
            if let eventSink = self.eventSink {
                eventSink(percent)
            }
        }, params: nil, checkCrc: false) { () -> Bool in
            return false
        }
        
        uploadManager?.putFile(filePath, key: key, token: token, complete: { (responseInfo, key, dict) in
            if dict == nil {
                result("")
            } else {
                result(key!)
            }
        }, option: option)
    }
    
    func uploadData(arguments: Any?, result: @escaping FlutterResult) {
        guard let arguments = arguments as? [String: Any],
            let flutterData = arguments["data"] as? FlutterStandardTypedData,
            let key = arguments["key"] as? String,
            let token = arguments["token"] as? String else {
                result("")
                return
        }
        
        let config = QNConfiguration.build { builder in
            // 设置区域，默认华东
            let zoneRaw = arguments["zone"] as? String ?? "0"
            builder?.setZone(self.getZone(raw: zoneRaw))
        }
        
        let uploadManager = QNUploadManager(configuration: config)
        
        let option = QNUploadOption(mime: nil, progressHandler: { (key, percent) in
            if let eventSink = self.eventSink {
                eventSink(percent)
            }
        }, params: nil, checkCrc: false) { () -> Bool in
            return false
        }
        
        uploadManager?.put(flutterData.data, key: key, token: token, complete: { (responseInfo, key, dict) in
            if dict == nil {
                result("")
            } else {
                result(key!)
            }
        }, option: option)
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

extension SwiftFlutterQiniuPlugin: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}
