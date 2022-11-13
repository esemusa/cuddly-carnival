import Combine
import SwiftUI

struct ContentView: View {

    private var sender: [Sender]

    @Environment(\.scenePhase) var scenePhase
    @State private var threshold: Int = -1

    @ObservedObject private var levelMeter: LevelMeter

    init(levelMeter: LevelMeter = LevelMeter(), sender: [Sender] = []) {
        self.levelMeter = levelMeter
        self.sender = sender
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
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

                NavigationLink(
                    destination: SettingsView(sender: sender)
                ) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 30.0))
                        .tint(.accentColor)
                }
                .padding(.bottom, 26)
                .padding(.trailing, 20)
            }
        }
    }

    private func levelDidChange(to level: Int) {
        if threshold != -1 && level > threshold {
            sender.forEach {
                $0.send()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
