import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("hasRequestedAlarmPermission") private var hasRequestedAlarmPermission = false

    var body: some View {
        if hasCompletedOnboarding {
            AlarmListView()
        } else {
            OnboardingView()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: AlarmModel.self, inMemory: true)
}
