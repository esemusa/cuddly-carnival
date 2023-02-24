import SwiftUI

@main
struct cuddly_carnivalApp: App {
    private var sender: [Sender] = {
        var sender: [Sender] = [
            AudioSignalSender(),
            LocalNotificationSender()
        ]

        #if DEBUG
        sender.append(DebugConsoleSender())
        #endif

        return sender
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView(sender: sender)
        }
    }
}
