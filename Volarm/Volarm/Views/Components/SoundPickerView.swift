import SwiftUI

struct SoundPickerView: View {
    @Binding var selectedSound: String
    private let sounds = SoundManager.shared.builtInSounds

    var body: some View {
        Picker("Sound", selection: $selectedSound) {
            ForEach(sounds) { sound in
                Text(sound.name).tag(sound.id)
            }
        }
    }
}

#Preview {
    SoundPickerView(selectedSound: .constant("default"))
        .padding()
        .background(Color.black)
}
