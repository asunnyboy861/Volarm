import Foundation
import SwiftData

@Model
final class AlarmModel {
    var id: UUID
    var name: String
    var hour: Int
    var minute: Int
    var isEnabled: Bool
    var selectedDays: [Int]
    var volume: Float
    var soundIdentifier: String
    var snoozeDuration: Int
    var isGradualVolume: Bool
    var gradualDuration: Int
    var groupID: UUID?
    var label: String
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        name: String = "Alarm",
        hour: Int = 7,
        minute: Int = 0,
        isEnabled: Bool = true,
        selectedDays: [Int] = [1, 2, 3, 4, 5],
        volume: Float = 0.8,
        soundIdentifier: String = "default",
        snoozeDuration: Int = 300,
        isGradualVolume: Bool = false,
        gradualDuration: Int = 30,
        groupID: UUID? = nil,
        label: String = "",
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.hour = hour
        self.minute = minute
        self.isEnabled = isEnabled
        self.selectedDays = selectedDays
        self.volume = volume
        self.soundIdentifier = soundIdentifier
        self.snoozeDuration = snoozeDuration
        self.isGradualVolume = isGradualVolume
        self.gradualDuration = gradualDuration
        self.groupID = groupID
        self.label = label
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var volumeColor: String {
        switch volume {
        case 0..<0.3: return "quiet"
        case 0.3..<0.6: return "medium"
        case 0.6..<0.8: return "loud"
        default: return "max"
        }
    }

    var timeString: String {
        String(format: "%02d:%02d", hour, minute)
    }

    var timeString12h: String {
        let h = hour % 12 == 0 ? 12 : hour % 12
        return String(format: "%d:%02d", h, minute)
    }

    var amPmString: String {
        hour < 12 ? "AM" : "PM"
    }

    var daySummary: String {
        if selectedDays.count == 7 { return "Every Day" }
        if selectedDays.isEmpty { return "One Time" }
        if selectedDays.sorted() == [1, 2, 3, 4, 5] { return "Weekdays" }
        if selectedDays.sorted() == [0, 6] { return "Weekends" }
        let dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        return selectedDays.sorted().map { dayNames[$0] }.joined(separator: " ")
    }
}
