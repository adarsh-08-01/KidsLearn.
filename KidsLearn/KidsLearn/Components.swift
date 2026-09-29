import SwiftUI
struct SubjectCard: View {
    let subject: Subject
    var body: some View {
        VStack(spacing: 12) {
            Text(subject.emoji)
                .font(.system(size: 60))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
            Text(subject.rawValue)
                .font(.title3.bold())
                .foregroundColor(.black.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.white.opacity(0.9))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(subject.tint.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: subject.tint.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}
struct ChoiceButton: View {
    let title: String
    let state: ChoiceState
    let tint: Color
    let action: () -> Void
    private var background: Color {
        switch state {
        case .idle: return tint.opacity(0.15)
        case .correct: return .green
        case .wrong: return .red.opacity(0.8)
        }
    }
    private var foregroundColor: Color {
        switch state {
        case .idle: return tint
        case .correct, .wrong: return .white
        }
    }
    private var borderColor: Color {
        switch state {
        case .idle: return tint.opacity(0.3)
        case .correct: return .clear
        case .wrong: return .clear
        }
    }
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity, minHeight: 88)
                .foregroundColor(foregroundColor)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(background)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(borderColor, lineWidth: 2)
                )
                .shadow(color: tint.opacity(0.1), radius: 8, x: 0, y: 4)
                .scaleEffect(state != .idle ? 0.95 : 1.0)
        }
        .buttonStyle(BounceButtonStyle())
        .disabled(state != .idle) 
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: state)
    }
}
struct BounceButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.5), value: configuration.isPressed)
    }
}
