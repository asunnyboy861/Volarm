import SwiftUI
import SwiftData
import StoreKit

struct AlarmEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @StateObject private var purchaseManager = PurchaseManager.shared
    @StateObject private var volumeManager = VolumeManager.shared

    let isNewAlarm: Bool

    @State private var name: String
    @State private var hour: Int
    @State private var minute: Int
    @State private var isEnabled: Bool
    @State private var selectedDays: [Int]
    @State private var volume: Float
    @State private var soundIdentifier: String
    @State private var snoozeDuration: Int
    @State private var isGradualVolume: Bool
    @State private var gradualDuration: Int
    @State private var label: String
    @State private var showingPaywall = false

    private var alarm: AlarmModel?

    init(alarm: AlarmModel? = nil, isNewAlarm: Bool) {
        self.isNewAlarm = isNewAlarm
        self.alarm = alarm
        _name = State(initialValue: alarm?.name ?? "Alarm")
        _hour = State(initialValue: alarm?.hour ?? 7)
        _minute = State(initialValue: alarm?.minute ?? 0)
        _isEnabled = State(initialValue: alarm?.isEnabled ?? true)
        _selectedDays = State(initialValue: alarm?.selectedDays ?? [1, 2, 3, 4, 5])
        _volume = State(initialValue: alarm?.volume ?? 0.8)
        _soundIdentifier = State(initialValue: alarm?.soundIdentifier ?? "default")
        _snoozeDuration = State(initialValue: alarm?.snoozeDuration ?? 300)
        _isGradualVolume = State(initialValue: alarm?.isGradualVolume ?? false)
        _gradualDuration = State(initialValue: alarm?.gradualDuration ?? 30)
        _label = State(initialValue: alarm?.label ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                timeSection
                volumeSection
                scheduleSection
                soundSection
                snoozeSection
                labelSection
            }
            .scrollContentBackground(.hidden)
            .background(Color.black)
            .navigationTitle(isNewAlarm ? "New Alarm" : "Edit Alarm")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveAlarm() }
                        .disabled(name.isEmpty)
                }
            }
            .sheet(isPresented: $showingPaywall) {
                paywallView
            }
        }
        .preferredColorScheme(.dark)
    }

    private var timeSection: some View {
        Section {
            HStack {
                Spacer()
                Picker("Hour", selection: $hour) {
                    ForEach(0..<24, id: \.self) { Text("\(String(format: "%02d", $0))").tag($0) }
                }
                .pickerStyle(.wheel)
                Text(":")
                    .font(.title)
                    .foregroundStyle(.white)
                Picker("Minute", selection: $minute) {
                    ForEach(0..<60, id: \.self) { Text("\(String(format: "%02d", $0))").tag($0) }
                }
                .pickerStyle(.wheel)
                Spacer()
            }
        } header: {
            TextField("Alarm Name", text: $name)
                .font(.headline)
                .foregroundStyle(.white)
        }
    }

    private var volumeSection: some View {
        Section {
            VolumeSliderView(volume: $volume)
                .onChange(of: volume) { _, _ in
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }

            HStack {
                Text("Volume")
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(Int(volume * 100))%")
                    .font(.title3.bold().monospacedDigit())
                    .foregroundStyle(Color.volumeColor(for: volume))
            }

            Toggle("Gradual Volume", isOn: $isGradualVolume)
                .tint(Color.volumeColor(for: volume))

            if isGradualVolume {
                Picker("Ramp Duration", selection: $gradualDuration) {
                    Text("10s").tag(10)
                    Text("20s").tag(20)
                    Text("30s").tag(30)
                    Text("60s").tag(60)
                }
            }

            Button {
                if !purchaseManager.isProUser {
                    showingPaywall = true
                } else {
                    volumeManager.playPreview(volume: volume, soundIdentifier: soundIdentifier)
                }
            } label: {
                Label("Preview Volume", systemImage: "speaker.wave.2.fill")
                    .foregroundStyle(Color.volumeColor(for: volume))
            }
        } header: {
            Label("Volume Control", systemImage: "speaker.wave.3.fill")
        }
    }

    private var scheduleSection: some View {
        Section {
            DayPickerView(selectedDays: $selectedDays)
        } header: {
            Label("Repeat", systemImage: "calendar")
        }
    }

    private var soundSection: some View {
        Section {
            SoundPickerView(selectedSound: $soundIdentifier)
        } header: {
            Label("Sound", systemImage: "bell.fill")
        }
    }

    private var snoozeSection: some View {
        Section {
            Picker("Snooze Duration", selection: $snoozeDuration) {
                Text("Off").tag(0)
                Text("1 min").tag(60)
                Text("3 min").tag(180)
                Text("5 min").tag(300)
                Text("10 min").tag(600)
                Text("15 min").tag(900)
            }
        } header: {
            Label("Snooze", systemImage: "repeat.circle.fill")
        }
    }

    private var labelSection: some View {
        Section {
            TextField("Label (optional)", text: $label)
        } header: {
            Label("Label", systemImage: "tag.fill")
        }
    }

    private var paywallView: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.yellow)

                Text("Volarm Pro")
                    .font(.title.bold())

                VStack(alignment: .leading, spacing: 12) {
                    Label("Unlimited alarms", systemImage: "checkmark.circle.fill")
                    Label("Gradual volume wake-up", systemImage: "checkmark.circle.fill")
                    Label("Custom sound import", systemImage: "checkmark.circle.fill")
                    Label("Alarm groups", systemImage: "checkmark.circle.fill")
                    Label("Widgets & Dynamic Island", systemImage: "checkmark.circle.fill")
                    Label("Siri & Shortcuts", systemImage: "checkmark.circle.fill")
                }
                .font(.body)

                if let product = purchaseManager.product {
                    Text(product.displayPrice)
                        .font(.title2.bold())
                    Text("One-time purchase • No subscription")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Button {
                    Task {
                        if await purchaseManager.purchase() {
                            showingPaywall = false
                        }
                    }
                } label: {
                    if purchaseManager.isLoading {
                        ProgressView()
                    } else {
                        Text("Unlock Pro")
                            .font(.headline)
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.volumeMedium)

                Button("Restore Purchases") {
                    Task { await purchaseManager.restorePurchases() }
                }
                .font(.caption)
            }
            .padding()
            .navigationTitle("Go Pro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { showingPaywall = false }
                }
            }
        }
    }

    private func saveAlarm() {
        if let existingAlarm = alarm {
            existingAlarm.name = name
            existingAlarm.hour = hour
            existingAlarm.minute = minute
            existingAlarm.isEnabled = isEnabled
            existingAlarm.selectedDays = selectedDays
            existingAlarm.volume = volume
            existingAlarm.soundIdentifier = soundIdentifier
            existingAlarm.snoozeDuration = snoozeDuration
            existingAlarm.isGradualVolume = isGradualVolume
            existingAlarm.gradualDuration = gradualDuration
            existingAlarm.label = label
            existingAlarm.updatedAt = Date()

            Task {
                do {
                    AlarmScheduler.shared.stopAlarm(id: existingAlarm.id)
                    if existingAlarm.isEnabled {
                        try await AlarmScheduler.shared.scheduleAlarm(existingAlarm)
                    }
                } catch {
                    print("Failed to reschedule alarm: \(error)")
                }
            }
        } else {
            let newAlarm = AlarmModel(
                name: name,
                hour: hour,
                minute: minute,
                isEnabled: isEnabled,
                selectedDays: selectedDays,
                volume: volume,
                soundIdentifier: soundIdentifier,
                snoozeDuration: snoozeDuration,
                isGradualVolume: isGradualVolume,
                gradualDuration: gradualDuration,
                label: label
            )
            modelContext.insert(newAlarm)

            Task {
                do {
                    try await AlarmScheduler.shared.scheduleAlarm(newAlarm)
                } catch {
                    print("Failed to schedule alarm: \(error)")
                }
            }
        }

        try? modelContext.save()
        dismiss()
    }
}
