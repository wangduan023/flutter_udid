import Flutter
import UIKit
import SAMKeychain
    
public class SwiftFlutterUdidPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_udid", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterUdidPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if("getUDID"==call.method){
        self.getUniqueDeviceIdentifierAsString(result: result);
    }
    else if("saveNewUDID"==call.method){
        self.saveUDID(result: result,udid : call.arguments[0])
    }
    else if("getNewUDID"==call.method){
        self.saveNewUDID(result: result)
    }
    else{
        result(FlutterMethodNotImplemented);
    }
  }

    private func saveUDID(result: FlutterResult, String udid){
            let query = SAMKeychainQuery()
            query.service = "####service####"
            query.account = "####account####"
            query.password = udid
            query.synchronizationMode = SAMKeychainQuerySynchronizationMode.no
            let res = "OK"
            do {
                try query.save()
            } catch let error as NSError {
                res= "KO"
                print("SAMKeychainQuery Exception: \(error)")
            }
            result(res)
    }

    private func getNewUDID(result: FlutterResult){
         var applicationUUID = SAMKeychain.password(forService: "####service####", account: "####account####")
        
        if applicationUUID == nil {
            result("")
        }
        result(applicationUUID)
    }   

    private func getUniqueDeviceIdentifierAsString(result: FlutterResult) {
        let bundleName = Bundle.main.infoDictionary!["CFBundleName"] as! String
        let accountName = Bundle.main.bundleIdentifier!
        
        var applicationUUID = SAMKeychain.password(forService: bundleName, account: accountName)
        
        if applicationUUID == nil {
            
            applicationUUID = (UIDevice.current.identifierForVendor?.uuidString)!
            let query = SAMKeychainQuery()
            query.service = bundleName
            query.account = accountName
            query.password = applicationUUID
            query.synchronizationMode = SAMKeychainQuerySynchronizationMode.no
            
            do {
                try query.save()
            } catch let error as NSError {
                print("SAMKeychainQuery Exception: \(error)")
            }
        }
        
        if(applicationUUID==nil||applicationUUID==""){
            result(FlutterError.init(code: "UNAVAILABLE",
                                     message: "UDID not available",
                                     details: nil));
        }else{
            result(applicationUUID)
        }
    }
}
