import UserNotifications
import AVFoundation
import AVFAudio
import SwiftUI

class AudioSignalSender: Sender {
    let icon: String = "bell"
    let settingDescription: String = "Benachrichtigung per Klingel. Ist auch während des Abspielens von Musik oder Filmen hörbar."
    let settingTitle: String = "Klingel"
    let senderTimeManager = SenderTimeManager()
    
    @AppStorage("setting.sender.audio")
    private(set) var setting: Int = 2
    private(set) var isRequestingPermission: Bool = false

    private var player: AVAudioPlayer?
    
    init() {
        player = try? AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Alarm", withExtension: "mp3")!)
    }
    
    func send() {
        // Check, if we are allowed to send again.
        guard senderTimeManager.checkTime(for: setting) else {
            return
        }

        player?.prepareToPlay()
        player?.play()
    }
    
    func save(setting: Int) {
        self.setting = setting
    }
    
    func hasPermission(_ checked: @escaping (Bool) -> Void) {
        checked(true)
    }
    
    func requestPermission(_ completion: @escaping (Bool, Error?) -> Void) {}
}
