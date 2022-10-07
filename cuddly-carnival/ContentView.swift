import Combine
import SwiftUI

struct ContentView: View {

    private var sender: [Sender]

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

    @State private var notificationButtonIsDisabled: Bool
    @State private var threshold: Double

    @ObservedObject private var levelMeter: LevelMeter

    init(notificationButtonIsDisabled: Bool = false, threshold: Double = 5.0, levelMeter: LevelMeter = LevelMeter(), sender: [Sender] = []) {
        self.notificationButtonIsDisabled = notificationButtonIsDisabled
        self.threshold = threshold
        self.levelMeter = levelMeter
        self.sender = sender
    }

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
            }.onReceive(levelMeter.$level) {
                levelDidChange(to: $0)
            }

            Button(action: onRecordButtonPressed) {
                Image(systemName: "power")
                    .font(.system(size: 56.0))
                    .foregroundColor(buttonColor)
            }.disabled(levelMeter.state == .permissionMissing)
        }.padding()
    }

    private func levelDidChange(to level: Double) {
        if level > threshold * 10 {
            sender.forEach {
                $0.send()
            }
        }
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
