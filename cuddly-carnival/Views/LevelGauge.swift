import SwiftUI

struct LevelGauge: View {
    var level: Double
    private let numberOfArcs: CGFloat = 10.0

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0.0) {
                ForEach(0 ..< 10) { i in
                    Arc()
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

    private func progress(
        value: Double,
        maxValue: Double,
        height: CGFloat
    ) -> CGFloat {
        let percentage = value / maxValue
        return height - (height * CGFloat(percentage))
    }
}

struct LevelElement_Previews: PreviewProvider {
    static var previews: some View {
        LevelGauge(level: 12.0)
    }
}
