import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var purchaseManager = PurchaseManager.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    Spacer(minLength: 20)

                    Image(systemName: "crown.fill")
                        .font(.system(size: 56))
                        .foregroundStyle(.yellow)
                        .shadow(color: .yellow.opacity(0.3), radius: 12)

                    Text("Volarm Pro")
                        .font(.title.bold())

                    Text("Unlock the full experience")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    VStack(alignment: .leading, spacing: 14) {
                        featureRow(icon: "alarm.fill", text: "Unlimited alarms")
                        featureRow(icon: "chart.line.uptrend.xyaxis", text: "Gradual volume wake-up")
                        featureRow(icon: "waveform.path", text: "Premium sound collection")
                        featureRow(icon: "folder.fill", text: "Alarm groups")
                        featureRow(icon: "square.grid.2x2.fill", text: "Widgets & Dynamic Island")
                        featureRow(icon: "mic.fill", text: "Siri & Shortcuts")
                    }
                    .padding(.horizontal, 8)

                    if let product = purchaseManager.product {
                        VStack(spacing: 4) {
                            Text(product.displayPrice)
                                .font(.title.bold())
                            Text("One-time purchase \u{2022} No subscription")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Button {
                        Task {
                            if await purchaseManager.purchase() {
                                dismiss()
                            }
                        }
                    } label: {
                        if purchaseManager.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                        } else {
                            Text("Unlock Pro")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.volumeMedium)
                    .foregroundStyle(.black)
                    .padding(.horizontal, 32)

                    Button("Restore Purchases") {
                        Task { await purchaseManager.restorePurchases() }
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)

                    Spacer(minLength: 20)
                }
                .padding()
            }
            .background(Color.black)
            .navigationTitle("Go Pro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private func featureRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(Color.volumeMedium)
                .frame(width: 24)
            Text(text)
                .font(.body)
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(Color.volumeMedium)
        }
    }
}

#Preview {
    PaywallView()
}
