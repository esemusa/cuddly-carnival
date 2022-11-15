import SwiftUI

struct SettingsView: View {
    @State private var stepperBindings = [Int]()
    private let sender: [Sender]
    
    var body: some View {
        Form {
            Text("Stelle hier ein, wie viel Zeit zwischen zwei Benachrichtigungen vergehen soll.\n\nDie **erste** Benachrichtigung kommt **sofort**!")
            ForEach(sender.indices, id: \.self) { index in
                if stepperBindings.count > index {
                    Section(header: Text(sender[index].settingTitle), footer: Text(sender[index].settingDescription)) {
                        HStack {
                            Image(systemName: sender[index].icon)
                                .font(.system(size: 25.0))
                            
                            Stepper(
                                value: $stepperBindings[index],
                                in: 1...Int.max
                            ) {
                                Text("Alle **\($stepperBindings[index].wrappedValue)** Sekunden")
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Einstellungen")
        .padding()
        .onAppear {
            let valuesForSender = sender.map {
                $0.setting
            }
            self.stepperBindings = valuesForSender
        }
        .onDisappear {
            zip(stepperBindings, sender).forEach { stepperValue, sender in
                sender.save(setting: stepperValue)
            }
        }
    }
    
    init(sender: [Sender]) {
        self.sender = sender
    }
}
