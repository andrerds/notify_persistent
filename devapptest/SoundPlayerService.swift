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
    
    func playRingtone() {
        // Obtém o caminho do som do ringtone padrão do sistema
        guard let ringtoneURL = Bundle.main.url(forResource: "ringtone", withExtension: "mp3") else {
            print("O arquivo de ringtone do sistema não pôde ser encontrado.")
            return
        }
        
        do {
            // Configura e inicia a reprodução do ringtone
            audioPlayer = try AVAudioPlayer(contentsOf: ringtoneURL)
            audioPlayer?.numberOfLoops = -1 // Reproduzir indefinidamente
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Erro ao inicializar o player de áudio: \(error.localizedDescription)")
        }
    }
    
    func stopRingtone() {
        audioPlayer?.stop()
    }
    
}
 
