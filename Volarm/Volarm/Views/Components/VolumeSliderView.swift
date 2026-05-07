import SwiftUI

struct VolumeSliderView: View {
    @Binding var volume: Float

    var body: some View {
        VStack(spacing: 8) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(hex: "#38383A") ?? .gray)
                        .frame(height: 12)

                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                stops: [
                                    .init(color: Color.volumeQuiet, location: 0.0),
                                    .init(color: Color.volumeQuiet, location: 0.3),
                                    .init(color: Color.volumeMedium, location: 0.3),
                                    .init(color: Color.volumeMedium, location: 0.6),
                                    .init(color: Color.volumeLoud, location: 0.6),
                                    .init(color: Color.volumeLoud, location: 0.8),
                                    .init(color: Color.volumeMax, location: 0.8),
                                    .init(color: Color.volumeMax, location: 1.0)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * CGFloat(volume), height: 12)

                    Circle()
                        .fill(.white)
                        .frame(width: 28, height: 28)
                        .shadow(radius: 4)
                        .overlay {
                            Circle()
                                .fill(Color.volumeColor(for: volume))
                                .frame(width: 20, height: 20)
                        }
                        .offset(x: geometry.size.width * CGFloat(volume) - 14)
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let newVolume = Float(max(0, min(1, value.location.x / geometry.size.width)))
                            volume = round(newVolume * 100) / 100
                        }
                )
            }
            .frame(height: 28)

            HStack {
                Label("Quiet", systemImage: "speaker.fill")
                    .font(.caption2)
                    .foregroundStyle(Color.volumeQuiet)
                Spacer()
                Label("Max", systemImage: "speaker.wave.3.fill")
                    .font(.caption2)
                    .foregroundStyle(Color.volumeMax)
            }
        }
    }
}

#Preview {
    VolumeSliderView(volume: .constant(0.6))
        .padding()
        .background(Color.black)
}
