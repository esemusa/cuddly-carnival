import SwiftUI

public typealias CompletionVoid = () -> Void

struct Arc: View {
    var isDisplaying: Bool
    var isThreshold: Bool
    var isThresholdBroken: Bool
    var isAboveThreshold: Bool
    var onTap: CompletionVoid

    private let contentLineWidth: CGFloat = 14
    private let borderLineWidth: CGFloat = 20

    private var borderColor: Color {
        if isAboveThreshold {
            return .ccDisabled
        } else if isThreshold {
            return .ccEnabled
        } else {
            return Color.ccArcBackground
        }
    }

    private var arcBackgroundColor: Color {
        if isThreshold || isAboveThreshold {
            return .ccArcBackground
        } else {
            return .ccArcBackgroundDisabled
        }
    }

    private var levelColor: Color {
        switch (isDisplaying, isThresholdBroken) {
        case (true, true):
            return .ccRed
        case (true, false):
            return .ccGreen
        default:
            return .clear
        }
    }
    
    var body: some View {
        ZStack {
            ArcPath()
                .stroke(
                    style: StrokeStyle(
                        lineWidth: borderLineWidth,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                .foregroundColor(borderColor)

            ArcPath()
                .stroke(
                    style: StrokeStyle(
                        lineWidth: contentLineWidth,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                .foregroundColor(arcBackgroundColor)

            ArcPath()
                .stroke(
                    style: StrokeStyle(
                        lineWidth: contentLineWidth,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                .foregroundColor(levelColor)

            // Almost fully transparent Arc over the actual arc to receive tap-gestures.
            // Setting this arc's opacity to 0 implicitly disabled tpuch gestures, so we set it to 0.000001.
            ArcPath()
                .stroke(
                    style: StrokeStyle(
                        lineWidth: 26,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                .foregroundColor(.white.opacity(0.000001))
                .onTapGesture {
                    onTap()
                }
        }
    }

    struct ArcPath: Shape {
        func path(in rect: CGRect) -> Path {
            Path { path in
                path.addArc(
                    center: CGPoint(
                        x: rect.size.width / 2,
                        y: rect.size.width / 2 + 55
                    ),
                    radius: rect.size.width / 2 + 35,
                    startAngle: .degrees(-40),
                    endAngle: .degrees(220),
                    clockwise: true
                )
            }
        }
    }
}

struct Arc_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Enabled, Displaying, !ThresholdBroken")
            Arc(isDisplaying: true, isThreshold: true, isThresholdBroken: false, isAboveThreshold: true, onTap: {})
            Text("Enabled, !Displaying, !ThresholdBroken")
            Arc(isDisplaying: false, isThreshold: true, isThresholdBroken: false, isAboveThreshold: false, onTap: {})
            Text("Enabled, Displaying, ThresholdBroken")
            Arc(isDisplaying: false, isThreshold: true, isThresholdBroken: true, isAboveThreshold: true, onTap: {})
            
            Text("Disabled, Displaying, ThresholdBroken")
            Arc(isDisplaying: true, isThreshold: false, isThresholdBroken: true, isAboveThreshold: false, onTap: {})
            Text("Disabled, !Displaying, ThresholdBroken")
            Arc(isDisplaying: false, isThreshold: false, isThresholdBroken: true, isAboveThreshold: true, onTap: {})
        }
    }
}
