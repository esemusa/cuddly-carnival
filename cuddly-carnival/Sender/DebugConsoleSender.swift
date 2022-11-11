import SwiftUI
import Foundation

class DebugConsoleSender: Sender {
    let settingTitle: String = "DEBUG SENDER"
    let senderTimeManager = SenderTimeManager()
    
    @AppStorage("setting.debug")
    private(set) var setting: Int = 20
    
    func send() {
        guard senderTimeManager.checkTime(for: setting) else { return }
        print("DEBUG SEND \(Date())")
    }

    func save(setting: Int) {
        self.setting = setting
    }
}
