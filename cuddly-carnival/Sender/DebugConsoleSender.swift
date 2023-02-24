import SwiftUI
import Foundation

class DebugConsoleSender: Sender {
    let icon: String = "bell"
    let settingDescription: String = "Diese Benachrichtigungen werden über die Konsole ausgegeben."
    let settingTitle: String = "DEBUG SENDER"
    let senderTimeManager = SenderTimeManager()
    
    @AppStorage("setting.debug")
    private(set) var setting: Int = 1
    private(set) var isRequestingPermission: Bool = false
    
    func send() {
        guard senderTimeManager.checkTime(for: setting) else { return }
        print("DEBUG SEND \(Date())")
    }

    func save(setting: Int) {
        self.setting = setting
    }
    
    func hasPermission(_ checked: @escaping (Bool) -> Void) {
        checked(true)
    }
    
    func requestPermission(_ completion: @escaping (Bool, Error?) -> Void) {
        completion(true, nil)
    }
}
