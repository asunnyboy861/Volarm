import SwiftUI

struct AlarmCardView: View {
    let alarm: AlarmModel

    var body: some View {
        HStack(spacing: 16) {
            VolumeIndicatorView(volume: alarm.volume)

            VStack(alignment: .leading, spacing: 4) {
                Text(alarm.timeString)
                    .font(.system(size: 36, weight: .light, design: .rounded))
                    .foregroundStyle(.white)

                Text(alarm.name)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 8) {
                    Text(alarm.daySummary)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    if !alarm.label.isEmpty {
                        Text("•")
                            .foregroundStyle(.secondary)
                        Text(alarm.label)
                            .font(.caption)
                            .foregroundStyle(Color.volumeColor(for: alarm.volume))
                    }
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(alarm.volume * 100))%")
                    .font(.caption.bold().monospacedDigit())
                    .foregroundStyle(Color.volumeColor(for: alarm.volume))

                Image(systemName: alarm.isEnabled ? "alarm.fill" : "alarm")
                    .foregroundStyle(alarm.isEnabled ? Color.volumeColor(for: alarm.volume) : .secondary)
                    .font(.title3)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    List {
        AlarmCardView(alarm: AlarmModel(name: "Work", hour: 7, minute: 0, volume: 1.0))
        AlarmCardView(alarm: AlarmModel(name: "Weekend", hour: 9, minute: 30, volume: 0.3))
        AlarmCardView(alarm: AlarmModel(name: "Nap", hour: 14, minute: 0, volume: 0.5))
    }
    .listStyle(.plain)
    .background(Color.black)
}
