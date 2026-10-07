import Foundation
import UserNotifications

final class NotificationManager {
    
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(
                options: [.alert, .sound, .badge]
            ) { granted, error in
                
                if let error {
                    print("Notification permission error: \(error)")
                    return
                }
                
                print("Notification permission: \(granted)")
            }
    }
    
    func scheduleLearningReminder(
        interval: TimeInterval
    ) {
        let center = UNUserNotificationCenter.current()
        
        center.removePendingNotificationRequests(
            withIdentifiers: ["learningReminder"]
        )
        
        let content = UNMutableNotificationContent()
        content.title = "Time to Learn! 📚"
        content.body = "Let's learn something new today! 🌟"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: interval,
            repeats: true
        )
        
        let request = UNNotificationRequest(
            identifier: "learningReminder",
            content: content,
            trigger: trigger
        )
        
        center.add(request) { error in
            if let error {
                print("Notification scheduling error: \(error)")
            }
        }
    }
    
    func cancelLearningReminder() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(
                withIdentifiers: ["learningReminder"]
            )
    }
}
