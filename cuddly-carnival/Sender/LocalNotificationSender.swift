import UserNotifications
import SwiftUI

class LocalNotificationSender: Sender {
    let settingTitle: String = "Benachrichtigungen"
    let senderTimeManager = SenderTimeManager()
    
    @AppStorage("setting.notification")
    private(set) var setting: Int = 20

    func send() {
        // Check, if we are allowed to send again.
        guard senderTimeManager.checkTime(for: setting) else {
            return
        }

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                let content = UNMutableNotificationContent()
                content.title = "Alarm!"
                content.subtitle = "Aufwachen!"
                content.sound = UNNotificationSound.default

                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                UNUserNotificationCenter.current().add(request)
            }
        }
    }
    
    func save(setting: Int) {
        self.setting = setting
    }
}
