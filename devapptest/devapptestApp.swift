import PushKit
import AVFAudio
import CallKit
import CoreHaptics

import UserNotifications
import SwiftUI
import UIKit
 

class AppDelegate: UIResponder, UIApplicationDelegate {
    var engine: CHHapticEngine?
    @State private var navigateToNotificationView: Bool = false
    @State private var notificationData: [AnyHashable: Any]?
    var vibrationService = VibrationService.shared
    let window = UIWindow(frame: UIScreen.main.bounds)
    var callManager = CallManager()
    var provider: CXProvider?
    
// MARK: didFinalauch
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        self.registerForPushNotifications()
        self.voipRegistration()
        self.initActionsNotications()
        //        self.setupCallKit()
        return true
    }

    // MARK:  Register for VoIP notifications
    func voipRegistration() {
        let mainQueue = DispatchQueue.main
        let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [PKPushType.voIP]
    }

    // MARK: Push notification setting
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

    // MARK:  Register push notification
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            [weak self] granted, error in
            guard let _ = self else { return }
            guard granted else { return }
            self?.getNotificationSettings()
        }
    }
    
    // MARK: initActionsNotications
    func initActionsNotications(){
        // Definir as ações e a categoria
        let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION", title: "Aceitar", options: [.foreground])
        let rejectAction = UNNotificationAction(identifier: "REJECT_ACTION", title: "Recusar", options: [.destructive])
        let category = UNNotificationCategory(identifier: "VISITOR_REQUEST", actions: [acceptAction, rejectAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

// MARK:- UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("didReceive ======", userInfo)
        // Update the state to navigate to NotificationView
        DispatchQueue.main.async {
            self.notificationData = userInfo
            self.navigateToNotificationView = true
        }
        
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

// MARK: Apresentar notificação
    func sendLocalNotification() {
       
        vibrationService.stopContinuousVibration()
        vibrationService.startContinuousVibration()
        
        let content = UNMutableNotificationContent()
        content.title = "Renann Antunes está querendo entrar"
        content.body = "Interaja com a notificação para Aceitar ou Recusar."
        content.categoryIdentifier = "VISITOR_REQUEST"
        content.interruptionLevel = .critical
        content.sound = UNNotificationSound.criticalSoundNamed(UNNotificationSoundName("sub.caf"))
   
        // Adicionando botões de texto diretamente no corpo da notificação
        content.userInfo = ["ACCEPT_ACTION": "ACCEPT_ACTION", "REJECT_ACTION": "REJECT_ACTION"]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                self.vibrationService.stopContinuousVibration()
                print("Erro ao adicionar notificação: \(error)")
            }
        }
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
        self.processData(payload: payload)
        completion()
    }
    
    private func processData(payload: PKPushPayload){
        let payloadDict = payload.dictionaryPayload["aps"] as? [String: Any] ?? [:]
        print("payload::::", payloadDict)
        self.sendLocalNotification()
        
    }
    
    private func registerCall(uuidCaller: String?, handle: String, callerName: String) {
        // Verificar se uuidCaller é uma string não vazia, caso contrário, gerar um novo UUID
        let uuid = (uuidCaller != nil && !uuidCaller!.isEmpty) ? UUID(uuidString: uuidCaller!) ?? UUID() : UUID()
        reportIncomingCall(uuid: uuid, handle: handle, callerName: callerName, hasVideo: false)
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
