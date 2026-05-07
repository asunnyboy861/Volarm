import SwiftUI

struct SoundPickerView: View {
    @Binding var selectedSound: String
    @State private var previewingSound: String?

    private let sounds = SoundManager.shared.builtInSounds

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(sounds) { sound in
                Button {
                    selectedSound = sound.id
                    previewSound(sound.id)
                } label: {
                    HStack {
                        Text(sound.name)
                            .font(.body)
                            .foregroundStyle(selectedSound == sound.id ? Color.volumeMedium : .white)

                        Spacer()

                        if previewingSound == sound.id {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.caption)
                                .foregroundStyle(Color.volumeMedium)
                        }

                        if selectedSound == sound.id {
                            Image(systemName: "checkmark")
                                .font(.caption.bold())
                                .foregroundStyle(Color.volumeMedium)
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(selectedSound == sound.id ? Color.volumeMedium.opacity(0.15) : Color.clear)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func previewSound(_ id: String) {
        previewingSound = id
        SoundManager.shared.playPreview(for: id, volume: 0.8)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if previewingSound == id {
                previewingSound = nil
                SoundManager.shared.stopPreview()
            }
        }
    }
}

#Preview {
    SoundPickerView(selectedSound: .constant("default"))
        .padding()
        .background(Color.black)
}
