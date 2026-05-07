import Foundation
import AlarmKit

nonisolated struct VolarmMetadata: AlarmMetadata {
    var alarmName: String
    var volume: Float
    var soundIdentifier: String

    init(alarmName: String = "", volume: Float = 0.8, soundIdentifier: String = "default") {
        self.alarmName = alarmName
        self.volume = volume
        self.soundIdentifier = soundIdentifier
    }
}
