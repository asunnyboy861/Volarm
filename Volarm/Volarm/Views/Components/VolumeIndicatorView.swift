import SwiftUI

struct VolumeIndicatorView: View {
    let volume: Float

    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<5, id: \.self) { index in
                RoundedRectangle(cornerRadius: 1.5)
                    .fill(barColor(for: index))
                    .frame(width: 4, height: barHeight(for: index))
            }
        }
    }

    private func barColor(for index: Int) -> Color {
        let threshold = Float(index) / 5.0
        return volume > threshold ? Color.volumeColor(for: volume) : Color(hex: "#38383A") ?? .gray
    }

    private func barHeight(for index: Int) -> CGFloat {
        CGFloat(8 + index * 4)
    }
}

#Preview {
    HStack {
        VolumeIndicatorView(volume: 0.2)
        VolumeIndicatorView(volume: 0.5)
        VolumeIndicatorView(volume: 0.7)
        VolumeIndicatorView(volume: 0.95)
    }
    .padding()
    .background(Color.black)
}
