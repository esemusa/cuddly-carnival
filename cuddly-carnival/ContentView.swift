import Combine
import SwiftUI
import UserNotifications

struct ContentView: View {
    
    let LEVEL_THRESHOLD: Float = -10.0

    private var buttonColor: Color {
        levelMeter.isMetering ? .red : .green
    }

    @State private var notificationButtonIsDisabled = false

    @ObservedObject private var levelMeter = LevelMeter()

    var body: some View {
        Text("Ding Dong")
            .font(.headline)

        VStack {
            LevelBar(level: levelMeter.level, label: "Links")

            Button(action: startRecording) {
                Image(systemName: "power")
                    .font(.system(size: 56.0))
                    .foregroundColor(buttonColor)
            }.disabled(!levelMeter.accessGranted)
        }

        Divider()

        Button("Test Notification") {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, _ in
                if success {
                    let content = UNMutableNotificationContent()
                    content.title = "Alarm!"
                    content.subtitle = "Aufwachen!"
                    content.sound = UNNotificationSound.default

                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                    
                    UNUserNotificationCenter.current().add(request)
                } else {
                    notificationButtonIsDisabled = true
                }
            }
        }.disabled(notificationButtonIsDisabled)
    }

    private func startRecording() {
        if levelMeter.isMetering {
            levelMeter.stop()
            return
        }

        levelMeter.start()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
