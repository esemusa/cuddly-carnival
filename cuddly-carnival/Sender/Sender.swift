import Foundation

protocol Sender {
    var settingTitle: String { get }
    var setting: Int { get }
    var senderTimeManager: SenderTimeManager { get }
    func send()
    func save(setting: Int)
}
