import SwiftUI

struct HomeView: View {
    
    @State private var showProfile = false
    @State private var showNotifications = false
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: Header
                    headerSection
                    
                    // MARK: Stats
                    statsSection
                    
                    // MARK: Explore
                    Text("Let's Explore ✨")
                        .font(.title2.bold())
                        .padding(.top, 8)
                        .foregroundColor(.black.opacity(0.8))
                        .shadow(
                            color: .white,
                            radius: 4,
                            x: 0,
                            y: 0
                        )
                    
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
        
        // MARK: Profile Sheet
        .sheet(isPresented: $showProfile) {
            ProfileView()
        }
        
        // MARK: Notification Sheet
        .sheet(isPresented: $showNotifications) {
            NotificationSettingsView()
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        HStack {
            
            // Profile Button
            Button {
                showProfile = true
            } label: {
                ProfileImageView()
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text("Hello, Friend! 👋")
                    .font(.title2.bold())
                    .foregroundColor(.black.opacity(0.8))
                    .shadow(
                        color: .white,
                        radius: 4,
                        x: 0,
                        y: 0
                    )
                
                Text("Ready to learn something new?")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .shadow(
                        color: .white,
                        radius: 4,
                        x: 0,
                        y: 0
                    )
            }
            
            Spacer()
            
            // Notification Button
            Button {
                showNotifications = true
            } label: {
                Image(systemName: "bell")
                    .font(.title2)
                    .foregroundColor(.black.opacity(0.7))
                    .padding(12)
                    .background(
                        Circle()
                            .fill(.white)
                    )
                    .shadow(
                        color: .black.opacity(0.05),
                        radius: 5,
                        x: 0,
                        y: 2
                    )
            }
            .buttonStyle(.plain)
        }
    }
    
    // MARK: - Stats Section
    
    private var statsSection: some View {
        HStack {
            
            StatItem(
                icon: "flame.fill",
                color: .orange,
                value: "7",
                title: "Day Streak"
            )
            
            Divider()
                .frame(height: 30)
            
            StatItem(
                icon: "star.circle.fill",
                color: .yellow,
                value: "120",
                title: "Coins"
            )
            
            Divider()
                .frame(height: 30)
            
            StatItem(
                icon: "rosette",
                color: .purple,
                value: "5",
                title: "Badges"
            )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
        )
        .shadow(
            color: .black.opacity(0.05),
            radius: 5,
            x: 0,
            y: 2
        )
    }
}

// MARK: - Stat Item

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
            
            VStack(alignment: .leading, spacing: 2) {
                
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

// MARK: - Profile Image

struct ProfileImageView: View {
    
    @AppStorage("profileImageData")
    private var profileImageData: Data?
    
    private var image: UIImage? {
        guard let data = profileImageData else {
            return nil
        }
        
        return UIImage(data: data)
    }
    
    var body: some View {
        Group {
            if let image {
                
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                
            } else {
                
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.blue)
                    .padding(4)
            }
        }
        .frame(width: 50, height: 50)
        .background(.white)
        .clipShape(Circle())
        .shadow(
            color: .black.opacity(0.08),
            radius: 5
        )
    }
}

#Preview {
    HomeView()
}
