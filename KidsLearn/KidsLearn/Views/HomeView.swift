import SwiftUI
struct HomeView: View {
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    statsSection
                    Text("Let's Explore ✨")
                        .font(.title2.bold())
                        .padding(.top, 8)
                        .foregroundColor(.black.opacity(0.8))
                        .shadow(color: .white, radius: 4, x: 0, y: 0)
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(Subject.allCases) { subject in
                            NavigationLink(value: subject) {
                                SubjectCard(subject: subject)
                            }
                            .buttonStyle(.plain) 
                        }
                    }
                }
                .padding()
            }
            .navigationDestination(for: Subject.self) { subject in 
                GameView(subject: subject) 
            }
            .background(
                Image("HomeBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            )
        }
    }
    private var headerSection: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)
                .background(Circle().fill(.white))
            VStack(alignment: .leading) {
                Text("Hello, Friend! 👋")
                    .font(.title2.bold())
                    .foregroundColor(.black.opacity(0.8))
                    .shadow(color: .white, radius: 4, x: 0, y: 0)
                Text("Ready to learn something new?")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .shadow(color: .white, radius: 4, x: 0, y: 0)
            }
            Spacer()
            Button(action: {}) {
                Image(systemName: "bell")
                    .font(.title2)
                    .foregroundColor(.black.opacity(0.7))
                    .padding(12)
                    .background(Circle().fill(.white))
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
            }
        }
    }
    private var statsSection: some View {
        HStack {
            StatItem(icon: "flame.fill", color: .orange, value: "7", title: "Day Streak")
            Divider().frame(height: 30)
            StatItem(icon: "star.circle.fill", color: .yellow, value: "120", title: "Coins")
            Divider().frame(height: 30)
            StatItem(icon: "rosette", color: .purple, value: "5", title: "Badges")
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
        )
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
struct StatItem: View {
    let icon: String
    let color: Color
    let value: String
    let title: String
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            VStack(alignment: .leading) {
                Text(value)
                    .font(.headline.bold())
                    .foregroundColor(.black.opacity(0.8))
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
#Preview {
    HomeView()
}
