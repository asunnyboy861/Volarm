import SwiftUI

struct AlarmCardView: View {
    let alarm: AlarmModel
    let onToggle: (Bool) -> Void

    private var disabledColor: Color {
        Color(hex: "#555555") ?? .gray
    }

    var body: some View {
        HStack(spacing: 16) {
            VolumeIndicatorView(volume: alarm.volume)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text(alarm.timeString12h)
                        .font(.system(size: 36, weight: .light, design: .rounded))
                        .foregroundStyle(alarm.isEnabled ? .white : disabledColor)
                    Text(alarm.amPmString)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(alarm.isEnabled ? Color(hex: "#8E8E93") ?? .gray : disabledColor)
                        .textCase(.uppercase)
                }

                Text(alarm.name)
                    .font(.subheadline)
                    .foregroundStyle(alarm.isEnabled ? Color(hex: "#8E8E93") ?? .gray : disabledColor)

                HStack(spacing: 8) {
                    Text(alarm.daySummary)
                        .font(.caption)
                        .foregroundStyle(alarm.isEnabled ? Color(hex: "#8E8E93") ?? .gray : disabledColor)

                    if !alarm.label.isEmpty {
                        Text("\u{2022}")
                            .foregroundStyle(Color(hex: "#8E8E93") ?? .gray)
                        Text(alarm.label)
                            .font(.caption)
                            .foregroundStyle(alarm.isEnabled ? Color.volumeColor(for: alarm.volume) : disabledColor)
                    }
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 8) {
                Toggle("", isOn: Binding(
                    get: { alarm.isEnabled },
                    set: { onToggle($0) }
                ))
                .tint(Color.volumeColor(for: alarm.volume))
                .labelsHidden()

                Text("\(Int(alarm.volume * 100))%")
                    .font(.caption2.bold().monospacedDigit())
                    .foregroundStyle(alarm.isEnabled ? Color.volumeColor(for: alarm.volume) : disabledColor)
            }
        }
        .padding(.vertical, 8)
        .opacity(alarm.isEnabled ? 1.0 : 0.5)
    }
}
