import Foundation
import AVFoundation
import UIKit

@MainActor
final class SoundManager {
    static let shared = SoundManager()

    struct SoundInfo: Identifiable, Hashable, Sendable {
        let id: String
        let name: String
        let systemSoundID: UInt32?
    }

    let builtInSounds: [SoundInfo] = [
        SoundInfo(id: "default", name: "Classic Alarm", systemSoundID: 1005),
        SoundInfo(id: "gentle_wake", name: "Gentle Wake", systemSoundID: 1013),
        SoundInfo(id: "digital_beep", name: "Digital Beep", systemSoundID: 1053),
        SoundInfo(id: "morning_bird", name: "Morning Bird", systemSoundID: 1020),
        SoundInfo(id: "ocean_wave", name: "Ocean Wave", systemSoundID: 1057)
    ]

    private var audioPlayer: AVAudioPlayer?
    private var currentPreviewID: String?

    private init() {}

    func getSoundURL(for identifier: String) -> URL? {
        if builtInSounds.contains(where: { $0.id == identifier }) {
            if let customURL = Bundle.main.url(forResource: identifier, withExtension: "mp3") {
                return customURL
            }
            if let customURL = Bundle.main.url(forResource: identifier, withExtension: "wav") {
                return customURL
            }
        }
        if let fallbackURL = Bundle.main.url(forResource: "classic_alarm", withExtension: "mp3") {
            return fallbackURL
        }
        if let fallbackURL = Bundle.main.url(forResource: "classic_alarm", withExtension: "wav") {
            return fallbackURL
        }
        return nil
    }

    func getSoundName(for identifier: String) -> String {
        builtInSounds.first(where: { $0.id == identifier })?.name ?? "Classic Alarm"
    }

    func getSystemSoundID(for identifier: String) -> UInt32? {
        builtInSounds.first(where: { $0.id == identifier })?.systemSoundID
    }

    func playSystemSound(for identifier: String) {
        if let soundID = getSystemSoundID(for: identifier) {
            AudioServicesPlaySystemSound(soundID)
        } else {
            AudioServicesPlaySystemSound(1005)
        }
    }

    func playPreview(for identifier: String, volume: Float) {
        stopPreview()
        currentPreviewID = identifier

        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, options: .mixWithOthers)
            try session.setActive(true)
        } catch {
            print("Audio session error: \(error)")
        }

        if let url = getSoundURL(for: identifier) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.volume = volume
                audioPlayer?.numberOfLoops = 0
                audioPlayer?.play()
            } catch {
                playSystemSound(for: identifier)
            }
        } else {
            playSystemSound(for: identifier)
        }
    }

    func stopPreview() {
        audioPlayer?.stop()
        audioPlayer = nil
        currentPreviewID = nil
    }

    var isPlaying: Bool {
        audioPlayer?.isPlaying == true
    }
}
