import Foundation

class SenderTimeManager {
    private var nextAllowedTry: Date? = nil
    
    func checkTime(for setting: Int) -> Bool {
        if let nextTry = nextAllowedTry, nextTry > Date.now {
            return false
        } else {
            nextAllowedTry = Date(timeIntervalSinceNow: TimeInterval(setting))
            return true
        }
    }
}
