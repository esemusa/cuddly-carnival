import Combine
import SwiftUI
import UserNotifications

struct ContentView: View {

    private var buttonColor: Color {
        switch levelMeter.state {

        case .active:
            return .red
        case .inactive:
            return .green
        case .permissionMissing:
            return .gray
        }
    }

    @State private var notificationButtonIsDisabled = false
    @State private var threshold: Double = 5.0

    @ObservedObject private var levelMeter = LevelMeter()

    var body: some View {
        Text("Ding Dong")
            .font(.headline)

        VStack(spacing: 20.0) {
            HStack {
                Spacer()
                LevelBar(level: levelMeter.level, label: "Links")
                Spacer()
                VSlider(value: $threshold, in: 0...10)
                Spacer()
            }

            Button(action: onRecordButtonPressed) {
                Image(systemName: "power")
                    .font(.system(size: 56.0))
                    .foregroundColor(buttonColor)
            }.disabled(levelMeter.state == .permissionMissing)
        }.padding()

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

    private func onRecordButtonPressed() {
        if levelMeter.state == .active {
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
