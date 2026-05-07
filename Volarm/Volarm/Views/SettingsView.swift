import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var purchaseManager = PurchaseManager.shared
    @State private var showingContact = false
    @State private var showingPaywall = false

    private let privacyURL = "https://asunnyboy861.github.io/Volarm/privacy.html"
    private let supportURL = "https://asunnyboy861.github.io/Volarm/support.html"

    var body: some View {
        NavigationStack {
            Form {
                proSection
                aboutSection
                legalSection
                supportSection
            }
            .scrollContentBackground(.hidden)
            .background(Color.black)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(isPresented: $showingContact) {
                ContactSupportView()
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
        }
        .preferredColorScheme(.dark)
    }

    private var proSection: some View {
        Section {
            if purchaseManager.isProUser {
                HStack {
                    Image(systemName: "crown.fill")
                        .foregroundStyle(.yellow)
                    Text("Volarm Pro")
                        .foregroundStyle(.white)
                    Spacer()
                    Text("Active")
                        .foregroundStyle(Color.volumeMedium)
                }
            } else {
                Button {
                    showingPaywall = true
                } label: {
                    HStack {
                        Image(systemName: "crown")
                            .foregroundStyle(.yellow)
                        Text("Upgrade to Pro")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Button {
                Task { await purchaseManager.restorePurchases() }
            } label: {
                Text("Restore Purchases")
            }
        } header: {
            Label("Pro", systemImage: "crown.fill")
        }
    }

    private var aboutSection: some View {
        Section {
            HStack {
                Text("Version")
                Spacer()
                Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                    .foregroundStyle(.secondary)
            }
            HStack {
                Text("Build")
                Spacer()
                Text(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1")
                    .foregroundStyle(.secondary)
            }
        } header: {
            Label("About", systemImage: "info.circle.fill")
        }
    }

    private var legalSection: some View {
        Section {
            Link(destination: URL(string: privacyURL)!) {
                HStack {
                    Label("Privacy Policy", systemImage: "hand.raised.fill")
                    Spacer()
                    Image(systemName: "arrow.up.right.square")
                        .foregroundStyle(.secondary)
                }
            }
            Link(destination: URL(string: supportURL)!) {
                HStack {
                    Label("Support Page", systemImage: "questionmark.circle.fill")
                    Spacer()
                    Image(systemName: "arrow.up.right.square")
                        .foregroundStyle(.secondary)
                }
            }
        } header: {
            Label("Legal", systemImage: "doc.text.fill")
        }
    }

    private var supportSection: some View {
        Section {
            Button {
                showingContact = true
            } label: {
                Label("Contact Support", systemImage: "envelope.fill")
            }
        } header: {
            Label("Support", systemImage: "headset")
        }
    }
}

#Preview {
    SettingsView()
}
