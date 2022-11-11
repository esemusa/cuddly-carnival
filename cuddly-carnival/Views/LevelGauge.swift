import SwiftUI

struct LevelGauge: View {
    var level: Int
    var isRecording: Bool
    @Binding var threshold: Int

    private let numberOfArcs: Int = 10

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0.0) {
                ForEach(0 ..< 10) { i in
                    Arc(
                        isDisplaying: calculateIsDisplaying(at: i),
                        isEnabled: actualIndex(for: i) <= threshold
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
                }

                Spacer(minLength: 20.0)

                ZStack {
                    Image(systemName: "speaker")
                        .font(.system(size: 100.0))
                        .multilineTextAlignment(.center)
                        .foregroundColor(isRecording ? .red : .gray)
                        .rotationEffect(Angle(degrees: 270))

                    Text("\(level) dB")
                }
            }
        }
    }

    private func calculateIsDisplaying(at i: Int) -> Bool {
        let steps = 100 / numberOfArcs
        let threshold = actualIndex(for: i) * Int(steps)
        return Int(level) > threshold
    }

    private func arcWidth(for geometry: GeometryProxy, at i: Int) -> CGFloat {
        geometry.size.width * CGFloat((CGFloat(numberOfArcs - i)) / CGFloat(numberOfArcs))
    }

    private func arcHeight(for geometry: GeometryProxy, at i: Int) -> CGFloat {
        let portion = geometry.size.height / CGFloat(numberOfArcs)
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
        LevelGauge(level: 51, isRecording: false, threshold: .constant(-1))
    }
}
