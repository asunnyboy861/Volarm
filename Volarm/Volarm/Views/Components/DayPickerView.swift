import SwiftUI

struct DayPickerView: View {
    @Binding var selectedDays: [Int]
    private let dayLabels = ["S", "M", "T", "W", "T", "F", "S"]

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<7, id: \.self) { index in
                Button {
                    toggleDay(index)
                } label: {
                    Text(dayLabels[index])
                        .font(.subheadline.bold())
                        .frame(width: 38, height: 38)
                        .background(
                            selectedDays.contains(index)
                                ? Color.volumeMedium
                                : Color(hex: "#38383A") ?? .gray
                        )
                        .foregroundStyle(
                            selectedDays.contains(index) ? .black : .secondary
                        )
                        .clipShape(Circle())
                }
            }
        }
    }

    private func toggleDay(_ day: Int) {
        if selectedDays.contains(day) {
            selectedDays.removeAll { $0 == day }
        } else {
            selectedDays.append(day)
            selectedDays.sort()
        }
    }
}

#Preview {
    DayPickerView(selectedDays: .constant([1, 2, 3, 4, 5]))
        .padding()
        .background(Color.black)
}
