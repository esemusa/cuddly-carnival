import SwiftUI

struct SettingsView: View {
    private let sender: [Sender]
    @State private var stepperBindings = [Int]()
    
    var body: some View {
        VStack {
            ForEach(sender.indices, id: \.self) { index in
                if stepperBindings.count > index {
                    VStack {
                        Text(sender[index].settingTitle)
                        Stepper(
                            "Benachrichtige mich alle \($stepperBindings[index].wrappedValue) Sekunden",
                            value: $stepperBindings[index]
                        )
                        Divider()
                    }
                }
                
            }
        }
        .onChange(of: stepperBindings) {
            zip($0, sender).forEach { stepperValue, sender in
                setSetting(for: sender.settingTitle, with: stepperValue)
            }
        }
        .onAppear {
            let valuesForSender = sender.map {
                getSetting(for: $0.settingTitle)
            }
            self.stepperBindings = valuesForSender
        }
    }
    
    init(sender: [Sender]) {
        self.sender = sender
    }
    
    private func getSetting(for setting: String) -> Int {
        UserDefaults.standard.integer(forKey: "settings.\(setting)")
    }
    
    private func setSetting(for setting: String, with value: Int) {
        UserDefaults.standard.setValue(value, forKey: "settings.\(setting)")
    }
}
