import SwiftUI

struct LevelGauge: View {
    var level: Int
    var isRecording: Bool
    @Binding var threshold: Int

    @State private var pulse = false
    @State private var timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()

    private let numberOfArcs: Int = 10

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0.0) {
                ForEach(0 ..< 10) { i in
                    Arc(
                        isDisplaying: calculateIsDisplaying(at: i),
                        isEnabled: actualIndex(for: i) <= threshold,
                        isThresholdBroken: thresholdBroken
                    ) {
                        if threshold == actualIndex(for: i) {
                            threshold = -1
                        } else {
                            threshold = actualIndex(for: i)
                        }
                    }
                    .frame(
                        width: arcWidth(for: geometry, at: i),
                        height: arcHeight(for: geometry, at: i)
                    )
                }.animation(.easeOut, value: level)

                Spacer(minLength: 20.0)

                ZStack {
                    Image(systemName: "record.circle")
                        .font(.system(size: 80.0))
                        .multilineTextAlignment(.center)
                        .foregroundColor(isRecordButtonActive ? .ccRed : .ccDisabled)
                        .rotationEffect(Angle(degrees: 270))

                    Text("\(level)")
                        .font(.system(size: 10.0))
                }
                .scaleEffect(pulse ? 1.0 : 0.92)
                .onReceive(timer) { input in
                    if isRecordButtonActive {
                        pulse.toggle()
                    } else {
                        pulse = true
                    }
                }
                .animation(.easeOut, value: pulse)
            }
        }
    }

    private var thresholdBroken: Bool {
        threshold != -1 && level >= threshold
    }

    private var isRecordButtonActive: Bool {
        isRecording && threshold >= 0
    }

    private func calculateIsDisplaying(at i: Int) -> Bool {
        let steps = 10 / numberOfArcs
        let threshold = actualIndex(for: i) * Int(steps)
        return Int(level) > threshold
    }

    private func arcWidth(for geometry: GeometryProxy, at i: Int) -> CGFloat {
        geometry.size.width * CGFloat((CGFloat(numberOfArcs - i)) / CGFloat(numberOfArcs))
    }

    private func arcHeight(for geometry: GeometryProxy, at i: Int) -> CGFloat {
        let portion = geometry.size.height / CGFloat(numberOfArcs) - 10
        let width = arcWidth(for: geometry, at: i)
        if width < portion {
            return width
        } else {
            return portion
        }
    }

    private func actualIndex(for i: Int) -> Int {
        numberOfArcs - i - 1
    }
}

struct LevelElement_Previews: PreviewProvider {
    static var previews: some View {
        LevelGauge(level: 3, isRecording: false, threshold: .constant(-1))
    }
}
