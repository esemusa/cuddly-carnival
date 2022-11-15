import Foundation

protocol Sender {
    var icon: String { get }
    var senderTimeManager: SenderTimeManager { get }
    var setting: Int { get }
    var settingTitle: String { get }
    var settingDescription: String { get }
    func send()
    func save(setting: Int)
}
