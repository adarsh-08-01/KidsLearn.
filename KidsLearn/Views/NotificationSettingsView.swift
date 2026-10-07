import SwiftUI

struct NotificationSettingsView: View {
    
    @AppStorage("notificationsEnabled")
    private var notificationsEnabled = false
    
    @AppStorage("notificationInterval")
    private var notificationInterval = 2
    
    var body: some View {
        NavigationStack {
            Form {
                
                // MARK: Notifications
                
                Section {
                    Toggle(
                        "Learning Reminders",
                        isOn: $notificationsEnabled
                    )
                    .onChange(of: notificationsEnabled) { enabled in
                        handleNotificationChange(enabled)
                    }
                } header: {
                    Text("Notifications")
                } footer: {
                    Text("Get reminders to come back and practice.")
                }
                
                
                // MARK: Reminder Frequency
                
                if notificationsEnabled {
                    Section("Reminder Frequency") {
                        
                        Picker(
                            "Remind me every",
                            selection: $notificationInterval
                        ) {
                            Text("1 hour")
                                .tag(1)
                            
                            Text("2 hours")
                                .tag(2)
                            
                            Text("4 hours")
                                .tag(4)
                            
                            Text("8 hours")
                                .tag(8)
                        }
                        .onChange(of: notificationInterval) { value in
                            scheduleReminder(hours: value)
                        }
                    }
                }
                
                
                // MARK: Permission
                
                Section {
                    Button("Request Notification Permission") {
                        NotificationManager.shared
                            .requestPermission()
                    }
                }
            }
            .navigationTitle("Notifications")
        }
    }
    
    
    // MARK: - Notification Toggle
    
    private func handleNotificationChange(_ enabled: Bool) {
        
        if enabled {
            
            NotificationManager.shared
                .requestPermission()
            
            scheduleReminder(
                hours: notificationInterval
            )
            
        } else {
            
            NotificationManager.shared
                .cancelLearningReminder()
        }
    }
    
    
    // MARK: - Schedule Reminder
    
    private func scheduleReminder(hours: Int) {
        
        let seconds = TimeInterval(
            hours * 60 * 60
        )
        
        NotificationManager.shared
            .scheduleLearningReminder(
                interval: seconds
            )
    }
}


#Preview {
    NotificationSettingsView()
}
