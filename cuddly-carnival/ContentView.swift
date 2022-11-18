import Combine
import SwiftUI

struct ContentView: View {

    private var sender: [Sender]

    @Environment(\.scenePhase) var scenePhase
    @State private var threshold: Int = -1
    @State private var lastThreshold: Int = -1
    
    @State private var showPermissionError: Bool = false

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
                        threshold: $threshold,
                        lastThreshold: $lastThreshold
                    )
                    .onReceive(levelMeter.$level) {
                        levelDidChange(to: $0)
                    }
                    .padding()
                    .onChange(of: threshold) {
                        if $0 != -1 {
                            lastThreshold = $0
                        }
                    }
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
                    .alert("Berechtigung nicht vergeben!", isPresented: $showPermissionError) {
                        Text("Verstanden")
                    } message: {
                        Text("Um Benachrichtigt zu werden benötigen wir die entsprechenden Berechtigungen.\nGehe in die Systemeinstellungen und aktiviere alle benötigten Berechtigungen für Cuddly-Carnival.")
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
        guard threshold != -1 else { return }
        
        func send(for sender: Sender) {
            if level > threshold {
                sender.send()
            }
        }
        
        sender.forEach { sender in
            guard !sender.isRequestingPermission else { return }

            sender.hasPermission { hasPermission in
                if hasPermission {
                    send(for: sender)
                } else {
                    sender.requestPermission { result, error in
                        if result {
                            send(for: sender)
                        } else {
                            threshold = -1
                            showPermissionError = true
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
