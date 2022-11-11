import SwiftUI

struct SettingsView: View {
    @State private var stepperBindings = [Int]()
    private let sender: [Sender]
    
    var body: some View {
        ScrollView {
            ForEach(sender.indices, id: \.self) { index in
                if stepperBindings.count > index {
                    VStack {
                        HStack {
                            Text(sender[index].settingTitle).bold()
                            Spacer()
                        }
                        Stepper(
                            "Benachrichtige mich alle \($stepperBindings[index].wrappedValue) Sekunden",
                            value: $stepperBindings[index],
                            in: 1...Int.max
                        )
                    }.padding()
                    Divider()
                }
            }
            Spacer()
        }
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
