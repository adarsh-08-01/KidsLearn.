import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @AppStorage("userName") private var userName = "Little Learner"
    @AppStorage("profileImageData") private var profileImageData: Data?
    
    @State private var editedName = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var showSavedMessage = false
    
    private var profileImage: UIImage? {
        guard let data = profileImageData else {
            return nil
        }
        
        return UIImage(data: data)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    profilePhotoSection
                    
                    nameSection
                    
                    learningStatsSection
                    
                    Button {
                        saveProfile()
                    } label: {
                        Text("Save Profile")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color.green)
                            )
                    }
                    .padding(.horizontal)
                    
                    if showSavedMessage {
                        Text("Profile saved! 🎉")
                            .font(.headline)
                            .foregroundColor(.green)
                    }
                }
                .padding()
            }
            .navigationTitle("My Profile")
            .navigationBarTitleDisplayMode(.inline)
            .background(
                Image("HomeBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            )
            .onAppear {
                editedName = userName
            }
        }
    }
    
    private var profilePhotoSection: some View {
        VStack(spacing: 12) {
            
            if let profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 5)
                    )
                    .shadow(radius: 8)
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.blue)
                    .background(
                        Circle()
                            .fill(.white)
                    )
            }
            
            PhotosPicker(
                selection: $selectedPhoto,
                matching: .images
            ) {
                Text("Change Photo")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            .onChange(of: selectedPhoto) { newValue in
                loadPhoto(from: newValue)
            }
        }
        .padding(.top, 10)
    }
    
    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Your Name")
                .font(.headline)
            
            TextField("Enter your name", text: $editedName)
                .font(.system(size: 18, design: .rounded))
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.white)
                )
        }
    }
    
    private var learningStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Learning Progress")
                .font(.title3.bold())
            
            HStack(spacing: 12) {
                ProfileStat(
                    icon: "flame.fill",
                    value: "7",
                    title: "Day Streak",
                    color: .orange
                )
                
                ProfileStat(
                    icon: "star.fill",
                    value: "120",
                    title: "Stars",
                    color: .yellow
                )
                
                ProfileStat(
                    icon: "trophy.fill",
                    value: "5",
                    title: "Badges",
                    color: .purple
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(.white.opacity(0.95))
        )
    }
    
    private func loadPhoto(from item: PhotosPickerItem?) {
        guard let item else { return }
        
        Task {
            if let data = try? await item.loadTransferable(type: Data.self) {
                await MainActor.run {
                    profileImageData = data
                }
            }
        }
    }
    
    private func saveProfile() {
        userName = editedName.isEmpty ? "Little Learner" : editedName
        
        withAnimation {
            showSavedMessage = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showSavedMessage = false
            }
        }
    }
}

struct ProfileStat: View {
    let icon: String
    let value: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.headline.bold())
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ProfileView()
}
