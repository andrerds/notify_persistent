//
//  VibrationService.swift
//  devapptest
//
//  Created by André de Souza on 16/04/24.
//

import Foundation
import AudioToolbox

final class VibrationService  {
    static let shared = VibrationService()
    
    /// Play a short single vibration, like a tac
    static func tacVibrate() {
        AudioServicesPlaySystemSound(1519) // one tack
    }

    /// Play three shorts tac vibration, like a tac tac tac
    static func threeTacVibrate() {
        AudioServicesPlaySystemSound(1521)
    }

    /// Play a strong boom vibration
    static func boomVibrate() {
        AudioServicesPlaySystemSound(1520)
    }

    /// Play a long vibrations trr trr, it sounds like an error
    static func longVibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate) // heavy tack
    }

    /// Stops the short single vibration, like a tac
    static func stopTacVibrate() {
        AudioServicesDisposeSystemSoundID(1519) // one tack
    }

    /// Stops the three shorts tac vibration, like a tac tac tac
    static func stopThreeTacVibrate() {
        AudioServicesDisposeSystemSoundID(1521)
    }

    /// Stops the strong boom vibration
    static func stopBoomVibrate() {
        AudioServicesDisposeSystemSoundID(1520)
    }

    /// Stops the long vibrations
    static func stopLongVibrate() {
        AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate) // heavy tack
    }

}
 
//class VibrationService: ObservableObject {
//    static let shared = VibrationService()
//    
//    @Published private var isVibrating = false
//    
//    func startContinuousVibration() {
//        DispatchQueue.main.async {
//            if !self.isVibrating {
//                self.isVibrating = true
//                self.vibrationLoop()
//            }
//        }
//    }
//    
//    func stopContinuousVibration() {
//        DispatchQueue.main.async {
//            self.isVibrating = false
//        }
//    }
//    
//    private func vibrationLoop() {
//        DispatchQueue.global(qos: .background).async { [weak self] in
//            while self?.isVibrating ?? false {
//                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
//                Thread.sleep(forTimeInterval: 0.5)
//            }
//        }
//    }
//}
