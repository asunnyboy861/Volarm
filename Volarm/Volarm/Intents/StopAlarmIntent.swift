import AppIntents

struct StopAlarmIntent: AppIntent {
    static var title: LocalizedStringResource = "Stop Alarm"
    static var description = IntentDescription("Stop a ringing alarm in Volarm")

    @Parameter(title: "Alarm ID")
    var alarmIDString: String

    func perform() async throws -> some IntentResult {
        guard let alarmID = UUID(uuidString: alarmIDString) else {
            return .result()
        }
        await AlarmScheduler.shared.stopAlarm(id: alarmID)
        return .result()
    }
}
