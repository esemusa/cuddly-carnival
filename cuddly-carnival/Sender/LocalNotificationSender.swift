import UserNotifications
import SwiftUI

class LocalNotificationSender: Sender {
    let icon: String = "bell"
    let settingDescription: String = "Benachrichtigung per Push. Werden auf all deinen verbundenen Geräten (Watch, iPad, Mac…) angezeigt."
    let settingTitle: String = "Push Benachrichtigungen"
    let senderTimeManager = SenderTimeManager()
    
    @AppStorage("setting.notification")
    private(set) var setting: Int = 10
    private(set) var isRequestingPermission: Bool = false
    
    func send() {
        // Check, if we are allowed to send again.
        guard senderTimeManager.checkTime(for: setting) else {
            return
        }

        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("Achtung!", comment: "Achtung!")
        content.subtitle = NSLocalizedString("Geräuschpegel überschritten!", comment: "Geräuschpegel überschritten!")

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
    
    func save(setting: Int) {
        self.setting = setting
    }
    
    func hasPermission(_ checked: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings {
            checked($0.authorizationStatus == .authorized)
        }
    }
    
    func requestPermission(_ completion: @escaping (Bool, Error?) -> Void) {
        isRequestingPermission = true
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge]) { [weak self] in
            self?.isRequestingPermission = false
            completion($0, $1)
        }
    }
}
