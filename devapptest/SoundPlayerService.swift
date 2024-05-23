//
//  SoundPlaye.swift
//  devapptest
//
//  Created by André de Souza on 16/04/24.
//

import AVFoundation
import UIKit

 

class SoundPlayer {
    static let shared = SoundPlayer()
    
    private var audioPlayer: AVAudioPlayer?
    
    func playSound(named soundName: String? = nil) {
        // Se um nome de som foi fornecido, tentamos reproduzi-lo
        if let soundName = soundName {
            if let soundURL = Bundle.main.url(forResource: soundName, withExtension: "mp3") {
                do {
                    // Configura e inicia a reprodução do som
                    audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                    audioPlayer?.numberOfLoops = -1 // Reproduzir indefinidamente
                    audioPlayer?.prepareToPlay()
                    audioPlayer?.play()
                } catch {
                    print("Erro ao inicializar o player de áudio: \(error.localizedDescription)")
                }
            } else {
                print("O arquivo de som não pôde ser encontrado.")
            }
        } else {
            // Se nenhum nome de som foi fornecido, paramos a reprodução de qualquer som atual
            audioPlayer?.stop()
        }
    }
    
    func stopSound() {
        audioPlayer?.stop()
    }
}
