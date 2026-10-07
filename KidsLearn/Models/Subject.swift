import SwiftUI
enum Subject: String, CaseIterable, Identifiable, Hashable {
    case counting = "Counting"
    case letters = "Letters"
    case addition = "Addition"
    case shapes = "Shapes"
    var id: String { rawValue }
    var emoji: String {
        switch self {
        case .counting: return "1️⃣"
        case .letters: return "🅰️"
        case .addition: return "➕"
        case .shapes: return "🔺"
        }
    }
    var tint: Color {
        switch self {
        case .counting: return .orange
        case .letters: return .purple
        case .addition: return .green
        case .shapes: return .pink
        }
    }
}
