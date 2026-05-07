import Foundation

@MainActor
final class SoundManager {
    static let shared = SoundManager()

    struct SoundInfo: Identifiable, Hashable, Sendable {
        let id: String
        let name: String
        let fileName: String?
    }

    let builtInSounds: [SoundInfo] = [
        SoundInfo(id: "default", name: "Classic Alarm", fileName: nil),
        SoundInfo(id: "gentle_wake", name: "Gentle Wake", fileName: "gentle_wake"),
        SoundInfo(id: "digital_beep", name: "Digital Beep", fileName: "digital_beep"),
        SoundInfo(id: "morning_bird", name: "Morning Bird", fileName: "morning_bird"),
        SoundInfo(id: "ocean_wave", name: "Ocean Wave", fileName: "ocean_wave")
    ]

    private init() {}

    func getSoundURL(for identifier: String) -> URL? {
        if identifier == "default" {
            return Bundle.main.url(forResource: "classic_alarm", withExtension: "mp3")
        }
        guard let sound = builtInSounds.first(where: { $0.id == identifier }),
              let fileName = sound.fileName else {
            return Bundle.main.url(forResource: "classic_alarm", withExtension: "mp3")
        }
        return Bundle.main.url(forResource: fileName, withExtension: "mp3")
    }

    func getSoundName(for identifier: String) -> String {
        builtInSounds.first(where: { $0.id == identifier })?.name ?? "Classic Alarm"
    }
}
