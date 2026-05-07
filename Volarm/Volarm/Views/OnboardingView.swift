import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("hasRequestedAlarmPermission") private var hasRequestedAlarmPermission = false
    @State private var currentPage = 0

    var body: some View {
        TabView(selection: $currentPage) {
            onboardingPage(
                icon: "alarm.fill",
                title: "Welcome to Volarm",
                subtitle: "The alarm app where every alarm\nhas its own volume",
                color: .volumeMedium
            )
            .tag(0)

            onboardingPage(
                icon: "speaker.wave.3.fill",
                title: "Per-Alarm Volume",
                subtitle: "Set a gentle 20% for weekends\nand a blaring 100% for workdays",
                color: .volumeLoud
            )
            .tag(1)

            onboardingPage(
                icon: "paintpalette.fill",
                title: "Color-Coded Volume",
                subtitle: "See volume at a glance:\nBlue = Quiet, Green = Medium,\nOrange = Loud, Red = Maximum",
                color: .volumeQuiet
            )
            .tag(2)

            onboardingPage(
                icon: "bell.badge.fill",
                title: "System-Level Reliability",
                subtitle: "Powered by AlarmKit\nAlarms break through Silent Mode\nand Focus Mode",
                color: .volumeMax
            )
            .tag(3)

            permissionPage
                .tag(4)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .preferredColorScheme(.dark)
    }

    private func onboardingPage(icon: String, title: String, subtitle: String, color: Color) -> some View {
        VStack(spacing: 32) {
            Spacer()
            Image(systemName: icon)
                .font(.system(size: 70))
                .foregroundStyle(color)
                .symbolEffect(.pulse, options: .repeating, value: currentPage)

            Text(title)
                .font(.title.bold())
                .foregroundStyle(.white)

            Text(subtitle)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()

            Button {
                withAnimation { currentPage += 1 }
            } label: {
                Text("Next")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(color)
                    .foregroundStyle(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
        }
        .background(Color.black)
    }

    private var permissionPage: some View {
        VStack(spacing: 32) {
            Spacer()
            Image(systemName: "checkmark.shield.fill")
                .font(.system(size: 70))
                .foregroundStyle(Color.volumeMedium)

            Text("Almost There!")
                .font(.title.bold())
                .foregroundStyle(.white)

            Text("Volarm needs alarm permission\nto wake you up reliably")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Spacer()

            Button {
                Task {
                    do {
                        _ = try await AlarmScheduler.shared.requestAuthorization()
                        hasRequestedAlarmPermission = true
                        withAnimation {
                            hasCompletedOnboarding = true
                        }
                    } catch {
                        hasRequestedAlarmPermission = true
                        withAnimation {
                            hasCompletedOnboarding = true
                        }
                    }
                }
            } label: {
                Text("Allow Alarms & Get Started")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.volumeMedium)
                    .foregroundStyle(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 32)

            Button {
                hasCompletedOnboarding = true
            } label: {
                Text("Skip")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 32)
        }
        .background(Color.black)
    }
}

#Preview {
    OnboardingView()
}
