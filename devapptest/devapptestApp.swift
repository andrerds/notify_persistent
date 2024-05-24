import PushKit
import CallKit
import UserNotifications
import SwiftUI
import UIKit
import ActivityKit

//class AppDelegate: UIResponder, UIApplicationDelegate {
//    var window: UIWindow?
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        let contentView = ContentView()
//        let hostingController = UIHostingController(rootView: contentView)
//        self.window?.rootViewController = hostingController
//        self.window?.makeKeyAndVisible()
//
//        self.registerForVoIPPushNotifications()
//        self.registerNotificationCategories()
//        UNUserNotificationCenter.current().delegate = self
//        
//        return true
//    }
//
//    func registerForVoIPPushNotifications() {
//        let voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
//        voipRegistry.delegate = self
//        voipRegistry.desiredPushTypes = [.voIP]
//    }
//
//    func registerNotificationCategories() {
//        let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION", title: "Accept", options: [.foreground])
//        let declineAction = UNNotificationAction(identifier: "DECLINE_ACTION", title: "Decline", options: [])
//        
//        let category = UNNotificationCategory(identifier: "CALL_INVITATION", actions: [acceptAction, declineAction], intentIdentifiers: [], options: [])
//        UNUserNotificationCenter.current().setNotificationCategories([category])
//    }
//}
//
//extension AppDelegate: UNUserNotificationCenterDelegate {
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//        let message = response.notification.request.content.body
//        
//        if response.actionIdentifier == "ACCEPT_ACTION" {
//            openNotificationView(with: message)
//        } else if response.actionIdentifier == "DECLINE_ACTION" {
//            // Handle decline action
//        } else {
//            openNotificationView(with: message)
//        }
//        
//        completionHandler()
//    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert, .sound, .badge])
//    }
//    
//    private func openNotificationView(with message: String) {
//        let notificationView = NotificationView(data: message)
//        let hostingController = UIHostingController(rootView: notificationView)
//        
//        if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
//            keyWindow.rootViewController?.present(hostingController, animated: true, completion: nil)
//        } else {
//            print("Error: No key window found")
//        }
//    }
//}
//extension AppDelegate: PKPushRegistryDelegate {
//    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
//        // Handle updated push credentials
//        let deviceToken = pushCredentials.token.map { String(format: "%02x", $0) }.joined()
//        print("Device Token: \(deviceToken)")
//    }
//    
//    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
//        print("Push token invalidated for type: \(type.rawValue)")
//    }
//    
//    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
//        let payloadDict = payload.dictionaryPayload["aps"] as? [String: Any] ?? [:]
//        let message = payloadDict["alert"] as! String
//        
//        if UIApplication.shared.applicationState == .active {
//            DispatchQueue.main.async {
//                let alert = UIAlertController(title: "VoIP Notification", message: message, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                
//                if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
//                    keyWindow.rootViewController?.present(alert, animated: true, completion: nil)
//                } else {
//                    print("Error: No key window found")
//                }
//            }
//        } else {
//            let content = UNMutableNotificationContent()
//            content.title = "Incoming Call"
//            content.body = message
//            content.categoryIdentifier = "CALL_INVITATION"
//            content.sound = UNNotificationSound.default
//            
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//            let request = UNNotificationRequest(identifier: "VoIPDemoIdentifier", content: content, trigger: trigger)
//            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//        }
//        completion()
//    }
//}


class AppDelegate: UIResponder, UIApplicationDelegate {

    let window = UIWindow(frame: UIScreen.main.bounds)
    var callManager = CallManager()
      var provider: CXProvider?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.registerForPushNotifications()
        self.voipRegistration()
        self.setupCallKit()
        return true
    }

    // Register for VoIP notifications
    func voipRegistration() {
        let mainQueue = DispatchQueue.main
        let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [PKPushType.voIP]
    }

    // Push notification setting
    func getNotificationSettings() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                UNUserNotificationCenter.current().delegate = self
                guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        } else {
            let settings = UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }

    // Register push notification
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            [weak self] granted, error in
            guard let _ = self else { return }
            guard granted else { return }
            self?.getNotificationSettings()
        }
    }
}

// MARK:- UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("didReceive ======", userInfo)
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("willPresent ======", userInfo)
        completionHandler([.alert, .sound, .badge])
    }
    
    //MARK: - Setup callKit
    
    func setupCallKit() {
           let configuration = CXProviderConfiguration(localizedName: "VoIP App")
           configuration.supportsVideo = false
           configuration.maximumCallGroups = 1
           configuration.maximumCallsPerCallGroup = 1
           
           provider = CXProvider(configuration: configuration)
           provider?.setDelegate(callManager, queue: nil)
       }
       
    func reportIncomingCall(uuid: UUID, handle: String, callerName: String, hasVideo: Bool = false) {
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: handle)
        update.localizedCallerName = callerName
        update.hasVideo = hasVideo
        update.supportsHolding = true
        update.supportsDTMF = true
        update.supportsGrouping = false
        update.supportsUngrouping = false

        provider?.reportNewIncomingCall(with: uuid, update: update, completion: { error in
            if let error = error {
                print("Error reporting incoming call: \(error.localizedDescription)")
            } else {
                print("Incoming call successfully reported.")
            }
        })
    }
    
}

//MARK: - PKPushRegistryDelegate
extension AppDelegate: PKPushRegistryDelegate {

    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        print(credentials.token)
        let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
        print("pushRegistry -> deviceToken :\(deviceToken)")
    }

    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("pushRegistry:didInvalidatePushTokenForType:")
    }
 
    // Handle incoming pushes
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        print("dictionaryPayload:::", payload.dictionaryPayload)
        
        let payloadDict = payload.dictionaryPayload["aps"] as? [String: Any] ?? [:]
        print("payload::::", payloadDict)
        
        let alertDict = payloadDict["alert"] as? [String: Any] ?? [:]
        let message = alertDict["body"] as! String
        let title = alertDict["title"] as! String
        let subtitle = alertDict["subtitle"] as! String
        let customData = payloadDict["customData"] as? [String: Any] ?? [:]
        
        print("title", title)
        print("subtitle", subtitle)
        print("customData::::", customData)
 
        // simular a ligacao
        let uuid = UUID()
        reportIncomingCall(uuid: uuid, handle: "123456789", callerName: message, hasVideo: false)
        completion()
    }
}

class CallManager: NSObject, CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {}
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        action.fulfill()
    }
}

@main
struct devapptestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
            }
        }
    }
}
