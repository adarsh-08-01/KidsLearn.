import SwiftUI
struct ResultView: View {
    let score: Int
    let total: Int
    let tint: Color
    let onRestart: () -> Void
    private var stars: Int {
        let percentage = Double(score) / Double(total)
        switch percentage {
        case 0.9...: return 3
        case 0.5...: return 2
        default: return 1
        }
    }
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Image(systemName: "trophy.fill")
                .font(.system(size: 100))
                .foregroundColor(.yellow)
                .shadow(color: .yellow.opacity(0.5), radius: 20, x: 0, y: 10)
            VStack(spacing: 8) {
                Text(stars == 3 ? "Amazing Job!" : "Good Try!")
                    .font(.system(size: 36, weight: .heavy, design: .rounded))
                    .foregroundColor(.black.opacity(0.8))
                Text("You scored \(score) out of \(total)")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            HStack(spacing: 16) {
                ForEach(0..<3, id: \.self) { index in
                    Image(systemName: index < stars ? "star.fill" : "star")
                        .font(.system(size: 56))
                        .foregroundColor(index < stars ? .yellow : .gray.opacity(0.3))
                        .scaleEffect(index < stars ? 1.1 : 1.0)
                }
            }
            .padding(.vertical, 20)
            Button(action: onRestart) {
                Text("Play Again")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .background(tint)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: tint.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .padding(.horizontal, 40)
            Spacer()
        }
        .background(
            Image("AppBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
        )
    }
}
