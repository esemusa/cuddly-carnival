import Foundation

protocol Sender {
    var icon: String { get }
    var senderTimeManager: SenderTimeManager { get }
    var setting: Int { get }
    var settingTitle: String { get }
    var settingDescription: String { get }
    func send()
    func save(setting: Int)
    
    // Permissions
    var isRequestingPermission: Bool { get }
    func hasPermission(_ checked: @escaping (Bool) -> Void)
    func requestPermission(_ completion: @escaping (Bool, Error?) -> Void)
}
