//
//  CallKitService.swift
//  devapptest
//
//  Created by André de Souza on 28/05/24.
//

import Foundation
import CallKit

final class CallKitService  {
    var callManager = CallManager()
    var provider: CXProvider?
    
    static let shared = CallKitService()
    
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
