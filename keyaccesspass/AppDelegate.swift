//
//  KeyAccess.swift
//  keyaccesspass
//
//  Created by André de Souza on 08/04/24.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseMessaging


class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    let gcmMessageIDKey = "gcm.message_id"
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initFirebase()
        setupPushNotifications()
        configureNotificationActions()
        
        if let notification = launchOptions?[.remoteNotification] as? [String: Any] {
            handleRemoteNotification(notification)
        }
        
        return true
    }
    
    func initFirebase(){
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
    }
    
    func setupPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge, .criticalAlert]) { granted, _ in
            print("Permission granted: \(granted)")
            guard granted else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func configureNotificationActions() {
        let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION", title: "Accept", options: [])
        let declineAction = UNNotificationAction(identifier: "DECLINE_ACTION", title: "Decline", options: [])
        let callNotificationCategory = UNNotificationCategory(identifier: "CALL_NOTIFICATION", actions: [acceptAction, declineAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([callNotificationCategory])
        
    }
    
    // MARK: - FCM apns TOKEN
    
    @objc func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcm = Messaging.messaging().fcmToken {
            print("fcm", fcm)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("pushnotificaiton", userInfo)
        
        let userInfoPayload = userInfo;
        let aps = userInfoPayload["aps"] as? [String: Any]
        let contentAvailable = aps?["content-available"] as? Int // push silensiosa
        
        guard let isContentAvailable = contentAvailable, isContentAvailable == 1 else {
            completionHandler(.noData)
            return
        }
        if UIApplication.shared.applicationState == .active {
            handleRemoteNotification(userInfo)
            
        } else if UIApplication.shared.applicationState == .background {
            print("IApplication.shared.applicationState == .background")
            setupRootViewController(data: userInfo)
            
        } else {
            print("Else IApplication.shared.applicationState == .background")
            setupRootViewController(data: userInfo)
        }
        
        
        
        completionHandler(.newData)
    }
    
    func setupRootViewController(data: Any) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let specificView = CustomNotificationView(data:data)
            let specificViewController = UIHostingController(rootView: specificView)
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = specificViewController
            window.windowLevel = .alert
            window.makeKeyAndVisible()
        }
    }
    
    func handleRemoteNotification(_ userInfo: [AnyHashable: Any]) {
        
        let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION", title: "Accept", options: [.foreground])
        let declineAction = UNNotificationAction(identifier: "DECLINE_ACTION", title: "Decline", options: [.destructive])
        let category = UNNotificationCategory(identifier: "CALL_NOTIFICATION", actions: [acceptAction, declineAction], intentIdentifiers: [], options: [.customDismissAction])
        let content = UNMutableNotificationContent()
        content.title = "Foreground Título da Notificação"
        content.body = "Corpo da Notificação"
        content.sound = .default
        content.categoryIdentifier = "CALL_NOTIFICATION"
        let request = UNNotificationRequest(identifier: "persistent_notification", content: content, trigger: nil)
        UNUserNotificationCenter.current().setNotificationCategories([category])
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error displaying persistent notification: \(error.localizedDescription)")
            }
        }
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(notification)
        completionHandler([.alert, .badge, .sound])
    }
    
    internal func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        
    }
    
 
    @main
    struct MyApp: App {
        @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
        var body: some Scene {
            WindowGroup {
                NavigationStack {
                    MainScreen()
                }
            }
        }
    }
}
