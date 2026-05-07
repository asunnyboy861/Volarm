import AppIntents

struct SnoozeAlarmIntent: AppIntent {
    static var title: LocalizedStringResource = "Snooze Alarm"
    static var description = IntentDescription("Snooze a ringing alarm in Volarm")

    @Parameter(title: "Alarm ID")
    var alarmIDString: String

    func perform() async throws -> some IntentResult {
        guard let alarmID = UUID(uuidString: alarmIDString) else {
            return .result()
        }
        await AlarmScheduler.shared.snoozeAlarm(id: alarmID)
        return .result()
    }
}
