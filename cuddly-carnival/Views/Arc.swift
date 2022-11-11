import SwiftUI

public typealias CompletionVoid = () -> Void

struct Arc: View {
    var isDisplaying: Bool
    var isEnabled: Bool
    var onTap: CompletionVoid

    private let contentLineWidth: CGFloat = 14
    private let borderLineWidth: CGFloat = 20

    private var borderColor: Color {
        if isEnabled {
            return .secondary
        } else {
            return .secondary.opacity(0.5)
        }
    }

    private var arcColor: Color {
        if isEnabled && isDisplaying {
            return .accentColor.opacity(0.85)
        } else if !isEnabled && isDisplaying {
            return .accentColor.opacity(0.2)
        } else if isEnabled && !isDisplaying {
            return .gray
        } else {
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
                .foregroundColor(arcColor)

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
            Text("Enabled and Displaying")
            Arc(isDisplaying: true, isEnabled: true, onTap: {})
            Text("Enabled and not Displaying")
            Arc(isDisplaying: false, isEnabled: true, onTap: {})

            Text("Disabled and Displaying")
            Arc(isDisplaying: true, isEnabled: false, onTap: {})
            Text("Disabled and NotDisplaying")
            Arc(isDisplaying: false, isEnabled: false, onTap: {})
        }
    }
}
