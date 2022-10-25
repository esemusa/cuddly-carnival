import SwiftUI

struct LevelElement: View {
    var level: Double
    private let numberOfArcs: CGFloat = 10.0
    private let borderColor: Color = .gray
    private let arcColor: Color = .white

    var body: some View {
        ZStack {
            Color(.systemBackground)
            VStack(spacing: 0.0) {
                GeometryReader { geometry in
                    ForEach(0 ..< 10) { i in
                        Arc()
                            .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                            .foregroundColor(borderColor)
                            .frame(
                                width: geometry.size.width * ((numberOfArcs - CGFloat(i)) / numberOfArcs),
                                height: geometry.size.height / numberOfArcs
                            )
                            .position(x: geometry.size.width / 2, y: CGFloat(i) * (geometry.size.height / numberOfArcs))

                        Arc()
                            .stroke(style: StrokeStyle(lineWidth: 13.0, lineCap: .round, lineJoin: .round))
                            .foregroundColor(arcColor.opacity(0.3))
                            .frame(
                                width: geometry.size.width * ((numberOfArcs - CGFloat(i)) / numberOfArcs),
                                height: geometry.size.height / numberOfArcs
                            )
                            .position(x: geometry.size.width / 2, y: CGFloat(i) * (geometry.size.height / numberOfArcs))
                    }
                }

                Image(systemName: "speaker")
                    .font(.system(size: 56.0))
                    .multilineTextAlignment(.center)
                    .foregroundColor(borderColor)
                    .rotationEffect(Angle(degrees: 270))
            }
        }
    }
}

struct LevelElement_Previews: PreviewProvider {
    static var previews: some View {
        LevelElement(level: 12.0)
    }
}
