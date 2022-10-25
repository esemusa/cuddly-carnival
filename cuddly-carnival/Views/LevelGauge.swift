import SwiftUI

struct LevelGauge: View {
    var level: Double
    private let numberOfArcs: CGFloat = 10.0

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0.0) {
                ForEach(0 ..< 10) { i in
                    Arc(isDisplaying: calculateIsDisplaying(at: i))
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
        return level > (160 / CGFloat(i))
    }

    private func arcWidth(for geometry: GeometryProxy, at i: Int) -> CGFloat {
        geometry.size.width * ((numberOfArcs - CGFloat(i)) / numberOfArcs)
    }

    private func arcHeight(for geometry: GeometryProxy, at i: Int) -> CGFloat {
        let portion = geometry.size.height / numberOfArcs
        let width = arcWidth(for: geometry, at: i)
        if width < portion {
            return width
        } else {
            return portion
        }
    }
}

struct LevelElement_Previews: PreviewProvider {
    static var previews: some View {
        LevelGauge(level: 50.0)
    }
}
