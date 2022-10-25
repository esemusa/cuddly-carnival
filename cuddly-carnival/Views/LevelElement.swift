import SwiftUI

struct LevelElement: View {
    var level: Double
    private let numberOfArcs: CGFloat = 10.0
    private let borderColor: Color = .gray
    private let arcColor: Color = .white

    var body: some View {

        VStack(spacing: 0.0) {
            GeometryReader { geometry in
                ForEach(0 ..< 10) { i in
                    ZStack {
                        Arc()
                            .stroke(
                                style: StrokeStyle(
                                    lineWidth: CGFloat(20 - i),
                                    lineCap: .round,
                                    lineJoin: .round
                                )
                            )
                            .foregroundColor(borderColor)
                            .frame(
                                width: geometry.size.width * ((numberOfArcs - CGFloat(i)) / numberOfArcs),
                                height: geometry.size.height / numberOfArcs
                            )
                            .position(
                                x: geometry.size.width / 2,
                                y: CGFloat(i) * (geometry.size.height / numberOfArcs)
                            )

                        Arc()
                            .stroke(
                                style: StrokeStyle(
                                    lineWidth: CGFloat(14 - i),
                                    lineCap: .round,
                                    lineJoin: .round
                                )
                            )
                            .foregroundColor(arcColor.opacity(0.3))
                            .frame(
                                width: geometry.size.width * ((numberOfArcs - CGFloat(i)) / numberOfArcs),
                                height: geometry.size.height / numberOfArcs
                            )
                            .position(
                                x: geometry.size.width / 2,
                                y: CGFloat(i) * (geometry.size.height / numberOfArcs)
                            )
                    }
                }
            }

            Image(systemName: "speaker")
                .font(.system(size: 56.0))
                .multilineTextAlignment(.center)
                .foregroundColor(borderColor)
                .rotationEffect(Angle(degrees: 270))
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
        LevelElement(level: 12.0)
    }
}
