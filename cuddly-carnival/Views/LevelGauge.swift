import SwiftUI

struct LevelGauge: View {
    var level: Int

    private let numberOfArcs: Int = 10
    @State private var tappedIndex: Int = -1

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0.0) {
                ForEach(0 ..< 10) { i in
                    Arc(isDisplaying: calculateIsDisplaying(at: i), isSelected: actualIndex(for: i) <= tappedIndex) {
                        if tappedIndex == actualIndex(for: i) {
                            tappedIndex = -1
                        } else {
                            tappedIndex = actualIndex(for: i)
                        }
                    }
                    .frame(
                        width: arcWidth(for: geometry, at: i),
                        height: arcHeight(for: geometry, at: i)
                    )
                }

                Spacer(minLength: 20.0)

                Image(systemName: "speaker")
                    .font(.system(size: 56.0))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .rotationEffect(Angle(degrees: 270))
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
        numberOfArcs - i + 1
    }
}

struct LevelElement_Previews: PreviewProvider {
    static var previews: some View {
        LevelGauge(level: 51)
    }
}
