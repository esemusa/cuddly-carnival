import SwiftUI

@main
struct cuddly_carnivalApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(sender: [LocalNotificationSender()])
        }
    }
}
