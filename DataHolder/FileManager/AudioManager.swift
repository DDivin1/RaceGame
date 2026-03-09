//
//  AudioManager.swift
//  RaceGame
//
//  Created by Dmitry Divin on 5.03.26.
//

import AVFoundation
import UIKit

// MARK: - Constants
private enum Constants {
    static let soundEnabledKey = "isSoundEnabled"
    static let backgroundMusicName = "gameTheme"
    static let backgroundMusicExtension = "mp3"
    static let crashSoundName = "crashSound"
    static let crashSoundExtension = "mp3"
    static let backgroundMusicVolume: Float = 0.2
    static let crashSoundVolume: Float = 0.5
    static let numberOfLoops = -1
}

// MARK: - AudioManager
final class AudioManager {

    // MARK: - Properties
    static let shared = AudioManager()
    private var player: AVAudioPlayer?
    private var crashPlayer: AVAudioPlayer?
    private var isPlaying = false
    
    private init() {}
    
    // MARK: - Public Methods
    func toggleSound() -> Bool {
        let wasEnabled = isSoundEnabled()
        
        if wasEnabled {
            UserDefaults.standard.set(false, forKey: Constants.soundEnabledKey)
            stopBackgroundMusic()
        } else {
            UserDefaults.standard.set(true, forKey: Constants.soundEnabledKey)
            startBackgroundMusic()
        }
        return isSoundEnabled()
    }
    
    func isSoundEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: Constants.soundEnabledKey)
    }
    
    func startBackgroundMusic() {
        guard !isPlaying else { return }
        guard let url = Bundle.main.url(forResource: Constants.backgroundMusicName,
                                       withExtension: Constants.backgroundMusicExtension) else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = Constants.numberOfLoops
            player?.play()
            player?.volume = Constants.backgroundMusicVolume
            isPlaying = true
        } catch {
            print("Error playing background music")
        }
    }
    
    func stopBackgroundMusic() {
        player?.stop()
        isPlaying = false
    }
    
    func playCrashSound() {
        guard let url = Bundle.main.url(forResource: Constants.crashSoundName,
                                       withExtension: Constants.crashSoundExtension) else { return }
        
        do {
            crashPlayer = try AVAudioPlayer(contentsOf: url)
            crashPlayer?.volume = Constants.crashSoundVolume
            crashPlayer?.play()
        } catch {
            print("Error playing crash sound")
        }
    }
    
    func updateButtonState(_ button: UIButton) {
        button.isSelected = !isSoundEnabled()
    }
}
