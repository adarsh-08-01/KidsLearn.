import SwiftUI

struct TestView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32)
                .fill(.white.opacity(0.85))
                .frame(maxWidth: 220, maxHeight: 220)
                .shadow(color: .blue.opacity(0.15), radius: 15, x: 0, y: 8)
            Text("🎈🎈🎈🎈")
                .font(.system(size: 100))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
    }
}
