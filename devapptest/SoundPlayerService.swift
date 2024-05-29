//
//  SoundPlaye.swift
//  devapptest
//
//  Created by André de Souza on 16/04/24.
//

import AVFoundation
import UIKit

 

class SoundPlayerService {
    static let shared = SoundPlayerService()
 
    private var audioPlayer: AVAudioPlayer?
    
    func playRingtone(loops: Int) {
//        Bundle.main.path(forResource: "out2.caf", ofType: nil)
        // Obtém o caminho do som do ringtone padrão do sistema
        guard let ringtoneURL = Bundle.main.path(forResource: "out2.caf", ofType: nil) else {
            print("O arquivo de ringtone do sistema não pôde ser encontrado.")
            return
        }
        print("SHOULD HEAR MUSIC NOW", ringtoneURL)
        let url = URL(fileURLWithPath: ringtoneURL)
        
        do {
            // Configura e inicia a reprodução do ringtone
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = loops // Reproduzir indefinidamente
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Erro ao inicializar o player de áudio: \(error.localizedDescription)")
        }
    }
    
    func stopRingtone() {
        audioPlayer?.stop()
    }
    
    // Configurar a sessão de áudio
    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting up audio session: \(error)")
        }
    }
    
}
 
