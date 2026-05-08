import SwiftUI
import SwiftData
import StoreKit

struct AlarmListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \AlarmModel.createdAt) private var alarms: [AlarmModel]
    @StateObject private var purchaseManager = PurchaseManager.shared
    @State private var showingAddAlarm = false
    @State private var showingSettings = false
    @State private var showingPaywall = false
    @State private var alarmToDelete: AlarmModel?
    @State private var showingDeleteConfirm = false
    @State private var selectedAlarm: AlarmModel?
    @State private var showingEditAlarm = false
    @State private var showingPermissionAlert = false
    @State private var showingScheduleError = false
    @State private var scheduleErrorMessage = ""

    private let freeAlarmLimit = 3

    private var canAddAlarm: Bool {
        purchaseManager.isProUser || alarms.count < freeAlarmLimit
    }

    private var enabledAlarms: [AlarmModel] {
        alarms.filter { $0.isEnabled }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                if alarms.isEmpty {
                    emptyStateView
                } else {
                    alarmListView
                }
            }
            .navigationTitle("Volarm")
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if !canAddAlarm {
                            showingPaywall = true
                        } else {
                            checkPermissionAndAddAlarm()
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddAlarm) {
                AlarmEditView(isNewAlarm: true)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
            .sheet(isPresented: $showingEditAlarm) {
                if let alarm = selectedAlarm {
                    AlarmEditView(alarm: alarm, isNewAlarm: false)
                }
            }
            .alert("Delete Alarm?", isPresented: $showingDeleteConfirm) {
                Button("Cancel", role: .cancel) {
                    alarmToDelete = nil
                }
                Button("Delete", role: .destructive) {
                    if let alarm = alarmToDelete {
                        deleteAlarm(alarm)
                        alarmToDelete = nil
                    }
                }
            } message: {
                if let alarm = alarmToDelete {
                    Text("\"\(alarm.name)\" will be permanently deleted.")
                }
            }
            .alert("Alarm Permission Required", isPresented: $showingPermissionAlert) {
                Button("Open Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Volarm needs alarm permission to schedule alarms. Please enable it in Settings.")
            }
            .alert("Scheduling Error", isPresented: $showingScheduleError) {
                Button("OK") { }
            } message: {
                Text(scheduleErrorMessage)
            }
        }
        .preferredColorScheme(.dark)
    }

    private var nextAlarmText: String? {
        guard !enabledAlarms.isEmpty else { return nil }

        let now = Date()
        let calendar = Calendar.current
        var nearestAlarm: AlarmModel?
        var nearestInterval: TimeInterval = .infinity

        for alarm in enabledAlarms {
            var components = calendar.dateComponents([.year, .month, .day], from: now)
            components.hour = alarm.hour
            components.minute = alarm.minute

            if let alarmDate = calendar.date(from: components) {
                var interval = alarmDate.timeIntervalSince(now)
                if interval < 0 {
                    interval += 86400
                }

                if alarm.selectedDays.isEmpty {
                    if interval < nearestInterval {
                        nearestInterval = interval
                        nearestAlarm = alarm
                    }
                } else {
                    let currentWeekday = calendar.component(.weekday, from: now) - 1
                    for day in alarm.selectedDays.sorted() {
                        var daysUntil = day - currentWeekday
                        if daysUntil < 0 { daysUntil += 7 }
                        if daysUntil == 0 && interval <= 0 { daysUntil = 7 }

                        let totalInterval = TimeInterval(daysUntil) * 86400 + interval
                        if totalInterval < nearestInterval {
                            nearestInterval = totalInterval
                            nearestAlarm = alarm
                        }
                    }
                }
            }
        }

        guard let _ = nearestAlarm else { return nil }

        if nearestInterval < 60 {
            return "Less than 1 min until next alarm"
        } else if nearestInterval < 3600 {
            let mins = Int(nearestInterval / 60)
            return "\(mins) min until next alarm"
        } else if nearestInterval < 86400 {
            let hours = Int(nearestInterval / 3600)
            let mins = Int((nearestInterval.truncatingRemainder(dividingBy: 3600)) / 60)
            return mins > 0 ? "\(hours) hr \(mins) min until next alarm" : "\(hours) hr until next alarm"
        } else {
            let days = Int(nearestInterval / 86400)
            let hours = Int((nearestInterval.truncatingRemainder(dividingBy: 86400)) / 3600)
            return hours > 0 ? "\(days) days \(hours) hr until next alarm" : "\(days) days until next alarm"
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "alarm.fill")
                .font(.system(size: 60))
                .foregroundStyle(Color.volumeMedium)
            Text("No Alarms Yet")
                .font(.title2.bold())
                .foregroundStyle(.white)
            Text("Tap + to create your first alarm\nwith its own volume level")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button {
                checkPermissionAndAddAlarm()
            } label: {
                Label("Add Alarm", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.volumeMedium)
                    .foregroundStyle(.black)
                    .clipShape(Capsule())
            }
        }
    }

    private var alarmListView: some View {
        List {
            if let nextText = nextAlarmText {
                Section {
                    HStack {
                        Image(systemName: "bell.badge.fill")
                            .foregroundStyle(Color.volumeMedium)
                        Text(nextText)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                .listRowBackground(Color(hex: "#1C1C1E"))
            }

            if !purchaseManager.isProUser && alarms.count >= freeAlarmLimit {
                Section {
                    Button {
                        showingPaywall = true
                    } label: {
                        HStack {
                            Image(systemName: "crown.fill")
                                .foregroundStyle(.yellow)
                            Text("Unlock Unlimited Alarms")
                                .font(.subheadline.bold())
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .listRowBackground(Color(hex: "#1C1C1E"))
            }

            ForEach(alarms) { alarm in
                AlarmCardView(alarm: alarm) { isEnabled in
                    toggleAlarm(alarm, isEnabled: isEnabled)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedAlarm = alarm
                    showingEditAlarm = true
                }
                .listRowBackground(Color(hex: "#1C1C1E"))
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        alarmToDelete = alarm
                        showingDeleteConfirm = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .frame(maxWidth: 720)
        .frame(maxWidth: .infinity)
    }

    private func checkPermissionAndAddAlarm() {
        Task {
            do {
                let authorized = try await AlarmScheduler.shared.requestAuthorization()
                if authorized {
                    showingAddAlarm = true
                } else {
                    showingPermissionAlert = true
                }
            } catch {
                showingPermissionAlert = true
            }
        }
    }

    private func toggleAlarm(_ alarm: AlarmModel, isEnabled: Bool) {
        alarm.isEnabled = isEnabled
        alarm.updatedAt = Date()

        Task {
            do {
                if isEnabled {
                    try await AlarmScheduler.shared.scheduleAlarm(alarm)
                } else {
                    AlarmScheduler.shared.cancelAlarm(id: alarm.id)
                }
            } catch {
                scheduleErrorMessage = "Failed to \(isEnabled ? "schedule" : "cancel") alarm: \(error.localizedDescription)"
                showingScheduleError = true
                alarm.isEnabled = !isEnabled
            }
        }

        try? modelContext.save()
    }

    private func deleteAlarm(_ alarm: AlarmModel) {
        AlarmScheduler.shared.cancelAlarm(id: alarm.id)
        modelContext.delete(alarm)
        try? modelContext.save()
    }
}

#Preview {
    AlarmListView()
        .modelContainer(for: AlarmModel.self, inMemory: true)
}
