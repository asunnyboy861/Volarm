import SwiftUI
import SwiftData

struct AlarmListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \AlarmModel.createdAt) private var alarms: [AlarmModel]
    @StateObject private var purchaseManager = PurchaseManager.shared
    @State private var showingAddAlarm = false
    @State private var showingSettings = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                if alarms.isEmpty {
                    emptyStateView
                } else {
                    alarmListView
                }
            }
            .navigationTitle("Volarm")
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddAlarm = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddAlarm) {
                AlarmEditView(isNewAlarm: true)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
        .preferredColorScheme(.dark)
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "alarm.fill")
                .font(.system(size: 60))
                .foregroundStyle(Color.volumeMedium)
            Text("No Alarms Yet")
                .font(.title2.bold())
                .foregroundStyle(.white)
            Text("Tap + to create your first alarm\nwith its own volume level")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button {
                showingAddAlarm = true
            } label: {
                Label("Add Alarm", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.volumeMedium)
                    .foregroundStyle(.black)
                    .clipShape(Capsule())
            }
        }
    }

    private var alarmListView: some View {
        List {
            ForEach(alarms) { alarm in
                NavigationLink {
                    AlarmEditView(alarm: alarm, isNewAlarm: false)
                } label: {
                    AlarmCardView(alarm: alarm)
                }
                .listRowBackground(Color(hex: "#1C1C1E"))
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        deleteAlarm(alarm)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private func deleteAlarm(_ alarm: AlarmModel) {
        AlarmScheduler.shared.cancelAlarm(id: alarm.id)
        modelContext.delete(alarm)
        try? modelContext.save()
    }
}

#Preview {
    AlarmListView()
        .modelContainer(for: AlarmModel.self, inMemory: true)
}
