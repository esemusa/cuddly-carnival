import UserNotifications

class LocalNotificationSender: Sender {
    private var nextAllowedTry: Date? = nil
    private let idleTime: Double = 20 // The seconds to wait until sending a new notification
    
    var settingTitle: String = "Benachrichtigungen"

    func send() {
        // Check, if we are allowed to send again.
        if let nextTry = nextAllowedTry, nextTry > Date.now {
            return
        }

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] success, error in
            if success {
                self?.nextAllowedTry = Date(timeIntervalSinceNow: self?.idleTime ?? 20)

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
}
