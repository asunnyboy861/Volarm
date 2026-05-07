import SwiftUI
import SwiftData

@main
struct VolarmApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: AlarmModel.self)
    }
}
