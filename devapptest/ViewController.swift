//
//  ViewController.swift
//  devapptest
//
//  Created by André de Souza on 16/04/24.
//

import Foundation
import UIKit
import PushKit
import CallKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(becomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        // Do any additional setup after loading the view.
    }

    @objc func becomeActive() {
        self.handleNotifData()
        
    }
    
        func handleNotifData() {
            let pref = UserDefaults.init(suiteName: "group.br.com.keyaccess.devapptest.notificationservice")
            let notifData = pref?.object(forKey: "NOTIF_DATA") as? NSDictionary
            let aps = notifData?["aps"] as? NSDictionary
            let alert = aps?["alert"] as? NSDictionary
            _ = alert?["body"] as? String
            print("viewController", pref)
     
        }
}

//class ViewController: UIViewController, CXProviderDelegate, PKPushRegistryDelegate {
    
//    
//    @IBOutlet weak var dataLbl: UILabel!
//    //    @IBOutlet weak var dataImg: UIImageView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        NotificationCenter.default.addObserver(self, selector: #selector(becomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
//        // Create a push registry object to request VoIP notification
//        let callRegistry = PKPushRegistry(queue: nil)
//        callRegistry.delegate = self
//        // Register to receive push notifications
//        callRegistry.desiredPushTypes = [PKPushType.voIP]
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        self.handleNotifData()
//    }
//    
//    func handleNotifData() {
//        let pref = UserDefaults.init(suiteName: "group.br.com.keyaccess.devapptest.notificationservice")
//        let notifData = pref?.object(forKey: "NOTIF_DATA") as? NSDictionary
//        let aps = notifData?["aps"] as? NSDictionary
//        let alert = aps?["alert"] as? NSDictionary
//        _ = alert?["body"] as? String
//        print("viewController", pref)
//        
//        // Getting image from UNNotificationAttachment
//        //        guard let imageData = pref?.object(forKey: "NOTIF_IMAGE") else { return }
//        //        guard let data = imageData as? Data else { return }
//        //        self.dataImg.image = UIImage(data: data)
//    }
//    
//    @objc func becomeActive() {
//        self.handleNotifData()
//    }
//    
//    
//    // Create an object to handle the receipt of PushKit notifications
//    func registerForVoIPCalls(_ voipRegistry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
//        
//        // Create an object to handle call configurations and settings
//        let callConfigObject = CXProviderConfiguration()
//        // Enable video calls
//        callConfigObject.supportsVideo = true;
//        // Show missed, received and sent calls in the phone app's Recents category
//        callConfigObject.includesCallsInRecents = true;
//        // Set a custom ring tone for incoming calls
//        callConfigObject.ringtoneSound = "ES_CellRingtone23.mp3"
//        
//        // Create an object to give update about call-related events
//        let callReport = CXCallUpdate()
//        // Display the name of the caller
//        callReport.remoteHandle = CXHandle(type: .generic, value: "Amos Gyamfi")
//        // Enable video call
//        callReport.hasVideo = true
//        
//        // Create an object to give update about incoming calls
//        let callProvider = CXProvider(configuration: callConfigObject)
//        callProvider.reportNewIncomingCall(with: UUID(), update: callReport, completion: { error in })
//        callProvider.setDelegate(self, queue: nil)
//    }
//    
//    // Call this function when the app receives push credentials
//    @objc(pushRegistry:didUpdatePushCredentials:forType:) func pushRegistry(_ voipRegistry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
//        // Display the iOS device token in the Xcode console
//        print(pushCredentials.token.map { String(format: "%02.2hhx", $0) }.joined())
//    }
//    
//    @objc func providerDidReset(_ callProvider: CXProvider) {
//        
//    }
//    
//}
