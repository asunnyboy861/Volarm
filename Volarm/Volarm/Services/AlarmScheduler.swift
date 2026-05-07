import SwiftUI
import AlarmKit
import ActivityKit
import Combine

@MainActor
final class AlarmScheduler: ObservableObject {
    static let shared = AlarmScheduler()
    private let alarmManager = AlarmManager.shared

    private init() {}

    func requestAuthorization() async throws -> Bool {
        switch alarmManager.authorizationState {
        case .authorized:
            return true
        case .notDetermined:
            let state = try await alarmManager.requestAuthorization()
            return state == .authorized
        case .denied:
            return false
        @unknown default:
            return false
        }
    }

    func scheduleAlarm(_ model: AlarmModel) async throws {
        let weekdays = convertToLocaleWeekdays(model.selectedDays)

        let schedule: Alarm.Schedule
        if weekdays.isEmpty {
            let time = Alarm.Schedule.Relative.Time(hour: model.hour, minute: model.minute)
            schedule = .relative(Alarm.Schedule.Relative(time: time, repeats: .never))
        } else {
            let time = Alarm.Schedule.Relative.Time(hour: model.hour, minute: model.minute)
            let recurrence = Alarm.Schedule.Relative.Recurrence.weekly(weekdays)
            schedule = .relative(Alarm.Schedule.Relative(time: time, repeats: recurrence))
        }

        let alertPresentation = AlarmPresentation.Alert(
            title: LocalizedStringResource(stringLiteral: model.name),
            stopButton: AlarmButton(
                text: "Stop",
                textColor: .white,
                systemImageName: "hand.raised.fill"
            ),
            secondaryButton: AlarmButton(
                text: "Snooze",
                textColor: .white,
                systemImageName: "repeat.circle.fill"
            ),
            secondaryButtonBehavior: .countdown
        )

        let countdownPresentation = AlarmPresentation.Countdown(
            title: LocalizedStringResource(stringLiteral: "Snoozing - \(model.name)"),
            pauseButton: AlarmButton(
                text: "Snooze",
                textColor: .white,
                systemImageName: "repeat.circle.fill"
            )
        )

        let presentation = AlarmPresentation(
            alert: alertPresentation,
            countdown: countdownPresentation
        )

        let countdownDuration = Alarm.CountdownDuration(
            preAlert: nil,
            postAlert: TimeInterval(model.snoozeDuration)
        )

        let tintColor = Color.volumeColor(for: model.volume)

        let attributes = AlarmAttributes(
            presentation: presentation,
            metadata: VolarmMetadata(
                alarmName: model.name,
                volume: model.volume,
                soundIdentifier: model.soundIdentifier
            ),
            tintColor: tintColor
        )

        let configuration = AlarmManager.AlarmConfiguration(
            countdownDuration: countdownDuration,
            schedule: schedule,
            attributes: attributes,
            secondaryIntent: nil,
            sound: .default
        )

        _ = try await alarmManager.schedule(id: model.id, configuration: configuration)
    }

    func stopAlarm(id: UUID) {
        try? alarmManager.stop(id: id)
    }

    func cancelAlarm(id: UUID) {
        try? alarmManager.cancel(id: id)
    }

    func snoozeAlarm(id: UUID) {
        try? alarmManager.countdown(id: id)
    }

    private func convertToLocaleWeekdays(_ days: [Int]) -> [Locale.Weekday] {
        let mapping: [Int: Locale.Weekday] = [
            0: .sunday,
            1: .monday,
            2: .tuesday,
            3: .wednesday,
            4: .thursday,
            5: .friday,
            6: .saturday
        ]
        return days.compactMap { mapping[$0] }
    }
}
