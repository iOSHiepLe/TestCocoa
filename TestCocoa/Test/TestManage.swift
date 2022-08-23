//
//  TestManage.swift
//  TestCocoa
//
//  Created by Le Minh Hiep on 23/08/2022.
//

import Foundation
import Flutter
import FlutterPluginRegistrant

public class TestManage {
    public static let instance = TestManage()
        
    private let sdk: TestSdk
    
    // ----- Request: Native --> Sdk -----//
    private let openHomePage = "sdk.open_home_page"
    private let openEventPage = "sdk.open_my_event_page"
    private let openTransferredPage = "sdk.open_transferred_ticket_page"
    private let openPendingPage = "sdk.open_pending_ticket_page"
    private let doSetProfile = "sdk.set_profile"
    private let doSetEnv = "sdk.set_environment"
    private let doSignOut = "sdk.do_sign_out"
    private let doSignIn = "sdk.do_sign_in"
    private let getAuthStatus = "sdk.get_auth_status"
    private let processPushMessage = "sdk.process_push_message"
    private let processPushDeviceToken = "sdk.process_push_device_token"
    
    // ----- Request: Sdk --> Native -----//
    private let onTokenExpired = "sdk.on_token_expired"
    private let onCloseButton = "sdk.on_close_button_pressed"
    private let onGetJwtToken = "sdk.get_jwt_token"
    private let onGetDeviceToken = "sdk.get_device_token"
    private let onInitialized = "sdk.initialized"
    private let onDebug = "sdk.debug"
    
    
    private init() {
        sdk = TestSdk.init()
    }
    
    /*
     Call this method to initialize SDK, and received isAuthenticated status in onInitializedHandler
     + onInitializedHandler: SDK return isAuthenticated to app
     + onTokenExpiredHandler: SDK request shouldRetry from app, if true, app should refresh token in advance
     + onGetJwtTokenHandler: SDK request jwtToken from app, it will be called whenever sdk request data from backend and during initialization
     + onGetDeviceTokenHandler: SDK request fcmDeviceToken from app
     + onCloseHandler: SDK notify app that user tap close button, app should close SDK UI and return to app UI
    */
    public func initialize(
        onInitializedHandler: @escaping ((_ isAuthenticated: Bool) -> Void),
        onTokenExpiredHandler: @escaping ((@escaping (_ shouldRetry: Bool) -> Void) -> Void),
        onGetJwtTokenHandler: @escaping ((@escaping (_ jwtToken: String?) -> Void) -> Void),
        onGetDeviceTokenHandler: @escaping ((@escaping (_ deviceToken: String?) -> Void) -> Void),
        onCloseHandler: @escaping () -> Void
    ) {
        sdk.initialize { (call, result) in
            let method = call.method
            let args = call.arguments
            if method == self.onInitialized {
                onInitializedHandler(args as! Bool)
                result(nil)
            } else if method == self.onGetJwtToken {
                onGetJwtTokenHandler { jwtToken in
                    result(jwtToken)
                }
            } else if method == self.onTokenExpired {
                onTokenExpiredHandler{ shouldRetry in
                    result(shouldRetry)
                }
            } else if method == self.onGetDeviceToken {
                onGetDeviceTokenHandler { deviceToken in
                    result(deviceToken)
                }
            } else if method == self.onCloseButton {
                onCloseHandler()
                result(nil)
            } else if method == self.onDebug {
                print("Debug log \(String(describing: args!))")
                result(nil)
            } else {
                print("Method \(method) - Arguments \(String(describing: args))")
                result(nil)
            }
        }
    }
    
    /*
     Call this method to sign in sdk, it must be called after the app finishes signin and get profile
     + completion: error == nil -> success
    */
    final func signIn(_ profile: TixngoProfile, completion: @escaping ((_ error: String?) -> Void)) {
        DispatchQueue.main.async {
            self.sdk.sendMessage(self.doSignIn, arguments: profile.toJson()) { error in
                completion(error as? String)
            }
        }
    }
    
    /*
     Call this method to sign out sdk when user do signout in app
    */
    final func signOut() {
        DispatchQueue.main.async {
            self.sdk.sendMessage(self.doSignOut, arguments: nil)
        }
    }
    
    /*
     Call this method to set profile to sdk when user profile is changed in app
    */
    final func setProfile(_ profile: TixngoProfile, completion: @escaping (() -> Void)) {
        DispatchQueue.main.async {
            self.sdk.sendMessage(self.doSetProfile, arguments: profile.toJson()) { _ in
                completion()
            }
        }
    }
    
    /*
     Get authentication status of sdk, when call this method, sdk will ask jwt token from app. If jwt is nil, sdk will always sent false
    */
    final func getAuthStatus(_ completion: @escaping ((_ isAuthenticated: Bool) -> Void)) {
        DispatchQueue.main.async {
            self.sdk.sendMessage(self.getAuthStatus, arguments: nil) { isAuthenticated in
                completion(isAuthenticated as! Bool)
            }
        }
    }
    
    /*
     Call this method to send push notification to sdk
    */
    final func processFcmMessageIfNeed(_ message: [String: Any]) {
        DispatchQueue.main.async {
            if let noti = TixngoPushNotification.init(message) {
                self.sdk.sendMessage(self.processPushMessage, arguments: noti.toJson())
            }
        }
    }
    
    /*
     Call this method to send Firebase device token to sdk
    */
    final func processFcmTokenIfNeed(_ deviceToken: String?) {
        DispatchQueue.main.async {
            self.sdk.sendMessage(self.processPushDeviceToken, arguments: deviceToken)
        }
    }
    
    /*
     Set environment of sdk
    */
    public func setEnv(_ env: TixngoEnv) {
        DispatchQueue.main.async {
            self.sdk.sendMessage(self.doSetEnv, arguments: env.rawValue)
        }
    }
    
    final func getCurrentPage() -> UIViewController {
        return sdk.rootViewController
    }
    
    final func getHomePage()  -> UIViewController {
        sdk.sendMessage(openHomePage, arguments: nil)
        return sdk.rootViewController
    }
    
    final func getEventPage() -> UIViewController {
        sdk.sendMessage(openEventPage, arguments: nil)
        return sdk.rootViewController
    }
    
    final func getTransferredTicketPage() -> UIViewController {
        sdk.sendMessage(openTransferredPage, arguments: nil)
        return sdk.rootViewController
    }
    
    final func getPendingTicketPage() -> UIViewController {
        sdk.sendMessage(openPendingPage, arguments: nil)
        return sdk.rootViewController
    }
}

class TestSdk {
    private let flutterEngine = FlutterEngine(name: "engine")
    
    private let channel: FlutterMethodChannel
    
    private let _rootViewController: FlutterViewController

    var rootViewController: UIViewController {
        get {
            return _rootViewController
        }
    }
    
    init() {
        channel = FlutterMethodChannel(name: "io.tixngo.sdk", binaryMessenger: flutterEngine.binaryMessenger)
        flutterEngine.run();
        GeneratedPluginRegistrant.register(with: flutterEngine)
        _rootViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
    }
    
    
    func initialize(_ handler: @escaping FlutterMethodCallHandler) {
        channel.setMethodCallHandler(handler)
    }
    
    func sendMessage(_ method: String, arguments: Any?, result: FlutterResult? = nil) {
        channel.invokeMethod(method, arguments: arguments, result: result)
    }
    
}

class TixngoProfile {
    
    private let firstName: String
    private let lastName: String
    private let gender: TixngoGender
    private let face: String?
    private let dateOfBirth: Date?
    private let nationality: String?
    private let passportNumber: String?
    private let idCardNumber: String?
    private let email: String?
    private let phoneNumber: String?
    private let address: TixngoAddress?
    private let birthCity: String?
    private let birthCountry: String?
    private let residenceCountry: String?
    
    init (firstName: String, lastName: String, gender: TixngoGender, face: String?, dateOfBirth: Date?, nationality: String?,
          passportNumber: String?, idCardNumber: String?, email: String?, phoneNumber: String?, address: TixngoAddress?,
          birthCity: String?, birthCountry: String?, residenceCountry: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.face = face
        self.dateOfBirth = dateOfBirth
        self.nationality = nationality
        self.passportNumber = passportNumber
        self.idCardNumber = idCardNumber
        self.email = email
        self.phoneNumber = phoneNumber
        self.address = address
        self.birthCity = birthCity
        self.birthCountry = birthCountry
        self.residenceCountry = residenceCountry
    }
    
    func toJson() -> [String: Any] {
        var result: [String: Any] = [
            "firstName" : firstName,
            "lastName": lastName,
            "gender": gender.rawValue
        ]
        if let face = face {
            result["face"] = face
        }
        if let dateOfBirth = dateOfBirth {
            result["dateOfBirth"] = dateOfBirth.toDobString()
        }
        if let nationality = nationality {
            result["nationality"] = nationality
        }
        if let passportNumber = passportNumber {
            result["passportNumber"] = passportNumber
        }
        if let idCardNumber = idCardNumber {
            result["idCardNumber"] = idCardNumber
        }
        if let email = email {
            result["email"] = email
        }
        if let phoneNumber = phoneNumber {
            result["phoneNumber"] = phoneNumber
        }
        if let address = address {
            result["address"] = address.toJson()
        }
        if let birthCity = birthCity {
            result["birthCity"] = birthCity
        }
        if let birthCountry = birthCountry {
            result["birthCountry"] = birthCountry
        }
        if let residenceCountry = residenceCountry {
            result["residenceCountry"] = residenceCountry
        }
        return result
    }
    
}

class TixngoAddress {
    
    private let line1: String
    private let line2: String?
    private let line3: String?
    private let city: String
    private let zip: String
    private let countryCode: String
    
    
    init (line1: String, line2: String?, line3: String?, city: String, zip: String, countryCode: String) {
        self.line1 = line1
        self.line2 = line2
        self.line3 = line3
        self.city = city
        self.zip = zip
        self.countryCode = countryCode
    }
    
    func toJson() -> [String: Any] {
        var result = [
            "line1" : line1,
            "city": city,
            "zip": zip,
            "countryCode": countryCode,
        ]
        if let line2 = line2 {
            result["line2"] = line2
        }
        if let line3 = line3 {
            result["line3"] = line3
        }
        return result
    }
    
}

class TixngoPushNotification {
    
    private let data: [String: Any]?
    private let notification: [String: Any]?
    
    
    init? (_ userInfo: [String: Any?]) {
        var data = [String: Any]()
        var notification = [String: Any]()
        
        var messageId: String?
        for (key, value) in userInfo {
            if key == "gcm.message_id" || key == "google.message_id" || key == "message_id" {
                messageId = value as? String
                continue
            }
            if key == "aps" {
                let aps = value as! [String: Any]
                if let title = aps["alert"] as? String {
                    notification["title"] = title
                }
                if let alert = aps["alert"] as? [String: Any] {
                    notification["body"] = alert["body"]
                    notification["title"] = alert["title"]
                }
                continue
            }
            if !(key == "fcm_options" || key == "to" || key == "from" || key == "collapse_key" || key == "message_type" || key.hasPrefix("google.") || key.hasPrefix("gcm.")) {
                data[key] = value
            }
        }
        if messageId != nil {
            self.data = data
            self.notification = notification
        } else {
            return nil
        }
    }
    
    func toJson() -> [String: Any] {
        var result = [String: Any]()
        if let data = data {
            result["data"] = data
        }
        if let notification = notification {
            result["notification"] = notification
        }
        return result
    }
    
}

public enum TixngoEnv: String {
    case demo       = "DEMO"
    case int        = "INT"
    case val        = "VAL"
    case preprod    = "PREPROD"
    case prod       = "PROD"
}

public enum TixngoGender: String {
    case male       = "male"
    case female     = "female"
    case other      = "other"
    case unknown    = "unknown"
}

fileprivate extension Date {
    func toDobString() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}

