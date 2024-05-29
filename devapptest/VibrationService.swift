//
//  VibrationService.swift
//  devapptest
//
//  Created by André de Souza on 16/04/24.
//
 
import AVFoundation
import UIKit
import CoreHaptics

final class VibrationService {
    static let shared = VibrationService()
    private var audioPlayer: AVAudioPlayer?
    private var vibrationTimer: Timer?
    private var engine: CHHapticEngine?

    private init() {
        prepareHaptics()
    }
    
    // Configurar a sessão de áudio
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting up audio session: \(error)")
        }
    }
    
    // Iniciar reprodução do áudio silencioso
    private func startSilentAudio() {
        // Start the background music:
        if let musicPath = Bundle.main.path(forResource: "out2.caf", ofType: nil) {
            print("SHOULD HEAR MUSIC NOW", musicPath)
            let url = URL(fileURLWithPath: musicPath)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.numberOfLoops = 2
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            }
            catch { print("Couldn't load music file") }
        }
    }
    
    // Preparar o motor de háptica
    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Haptic engine Creation Error: \(error)")
        }
    }
    
    // Função para vibrar
    @objc private func vibrate() {
        let vibrationID: SystemSoundID = 4095
        AudioServicesPlaySystemSound(vibrationID)
    }
    
    // Iniciar vibração contínua
    func startContinuousVibration() {
        setupAudioSession()
        startSilentAudio()
        vibrationTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(vibrate), userInfo: nil, repeats: true)
    }
    
    // Parar vibração contínua
    func stopContinuousVibration() {
        print("parando...")
        audioPlayer?.stop()
        vibrationTimer?.invalidate()
        vibrationTimer = nil
    }
}


