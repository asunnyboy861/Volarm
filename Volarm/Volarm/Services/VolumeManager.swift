import Foundation
import AVFoundation
import Combine

@MainActor
final class VolumeManager: ObservableObject {
    static let shared = VolumeManager()
    private var audioPlayer: AVAudioPlayer?
    private var fadeTimer: Timer?

    private init() {}

    func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, options: .mixWithOthers)
            try session.setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }

    func playPreview(volume: Float, soundIdentifier: String) {
        stopPreview()
        configureAudioSession()

        guard let url = SoundManager.shared.getSoundURL(for: soundIdentifier) else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = volume
            audioPlayer?.numberOfLoops = 0
            audioPlayer?.play()
        } catch {
            print("Failed to play preview: \(error)")
        }
    }

    func playWithGradualVolume(targetVolume: Float, duration: Int, soundIdentifier: String) {
        stopPreview()
        configureAudioSession()

        guard let url = SoundManager.shared.getSoundURL(for: soundIdentifier) else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = 0.0
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()

            let stepInterval: TimeInterval = 0.5
            let totalSteps = Double(duration) / stepInterval
            let volumeStep = targetVolume / Float(totalSteps)

            fadeTimer = Timer.scheduledTimer(withTimeInterval: stepInterval, repeats: true) { [weak self] timer in
                Task { @MainActor in
                    guard let self, let player = self.audioPlayer else {
                        timer.invalidate()
                        return
                    }
                    let newVolume = min(player.volume + volumeStep, targetVolume)
                    player.volume = newVolume
                    if newVolume >= targetVolume {
                        timer.invalidate()
                        self.fadeTimer = nil
                    }
                }
            }
        } catch {
            print("Failed to play with gradual volume: \(error)")
        }
    }

    func stopPreview() {
        fadeTimer?.invalidate()
        fadeTimer = nil
        audioPlayer?.stop()
        audioPlayer = nil
    }
}
