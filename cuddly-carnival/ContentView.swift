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

    @Environment(\.scenePhase) var scenePhase
    @State private var threshold: Int = -1

    @ObservedObject private var levelMeter: LevelMeter

    init(levelMeter: LevelMeter = LevelMeter(), sender: [Sender] = []) {
        self.levelMeter = levelMeter
        self.sender = sender
    }

    var body: some View {
        VStack {
            LevelGauge(
                level: levelMeter.level,
                isRecording: levelMeter.state == .active,
                threshold: $threshold
            )
            .onReceive(levelMeter.$level) {
                levelDidChange(to: $0)
            }
            .padding()
            .onChange(of: scenePhase) { newPhase in
                switch newPhase {
                case .active:
                    levelMeter.start()
                default:
                    if threshold == -1 {
                        levelMeter.stop()
                    }
                }
            }
        }
    }

    private func levelDidChange(to level: Int) {
        if level > threshold {
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
