import SwiftUI

struct ContactSupportView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var topic = "General"
    @State private var name = ""
    @State private var email = ""
    @State private var message = ""
    @State private var isSending = false
    @State private var showSuccess = false
    @State private var errorMessage: String?

    private let topics = ["General", "Bug Report", "Feature Request", "Billing", "Other"]
    private let feedbackURL: String

    init() {
        let url = ProcessInfo.processInfo.environment["FEEDBACK_BACKEND_URL"]
            ?? "https://feedback-board.iocompile67692.workers.dev"
        self.feedbackURL = url
    }

    private var isFormValid: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && email.contains("@")
        && !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                topicSection
                nameSection
                emailSection
                messageSection
                submitSection
            }
            .scrollContentBackground(.hidden)
            .background(Color.black)
            .navigationTitle("Contact Us")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
            .alert("Thank You!", isPresented: $showSuccess) {
                Button("OK") { dismiss() }
            } message: {
                Text("Your feedback has been sent. We'll get back to you soon.")
            }
            .alert("Error", isPresented: .constant(errorMessage != nil)) {
                Button("OK") { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "")
            }
        }
        .preferredColorScheme(.dark)
    }

    private var topicSection: some View {
        Section {
            Picker("Topic", selection: $topic) {
                ForEach(topics, id: \.self) { t in
                    Text(t).tag(t)
                }
            }
            .pickerStyle(.menu)
        } header: {
            Label("Topic", systemImage: "tag.fill")
        }
    }

    private var nameSection: some View {
        Section {
            TextField("Your name (optional)", text: $name)
                .textContentType(.name)
        } header: {
            Label("Name", systemImage: "person.fill")
        }
    }

    private var emailSection: some View {
        Section {
            TextField("Your email", text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
        } header: {
            Label("Email", systemImage: "envelope.fill")
        }
    }

    private var messageSection: some View {
        Section {
            TextEditor(text: $message)
                .frame(minHeight: 120)
        } header: {
            Label("Message", systemImage: "text.bubble.fill")
        }
    }

    private var submitSection: some View {
        Section {
            Button {
                sendMessage()
            } label: {
                HStack {
                    Spacer()
                    if isSending {
                        ProgressView()
                    } else {
                        Text("Send Feedback")
                            .font(.headline)
                    }
                    Spacer()
                }
            }
            .disabled(!isFormValid || isSending)
        }
    }

    private func sendMessage() {
        isSending = true
        errorMessage = nil

        guard let url = URL(string: feedbackURL) else {
            isSending = false
            errorMessage = "Invalid feedback URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = [
            "app": "Volarm",
            "topic": topic,
            "name": name,
            "email": email.trimmingCharacters(in: .whitespacesAndNewlines),
            "message": message,
            "bundle_id": Bundle.main.bundleIdentifier ?? "com.zzoutuo.Volarm"
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                isSending = false
                if let error = error {
                    errorMessage = error.localizedDescription
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    showSuccess = true
                } else {
                    errorMessage = "Failed to send feedback. Please try again."
                }
            }
        }.resume()
    }
}

#Preview {
    ContactSupportView()
}
