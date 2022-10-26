import SwiftUI

public typealias CompletionVoid = () -> Void

struct Arc: View {
    var isDisplaying: Bool
    var isSelected: Bool
    var onTap: CompletionVoid

    private let contentLineWidth: CGFloat = 14
    private let borderLineWidth: CGFloat = 20
    private var borderColor: Color {
        if isSelected {
            return .gray
        } else {
            return .gray.opacity(0.3)
        }
    }
    private var arcColor: Color {
        if isDisplaying {
            return .yellow
        } else {
            return .white.opacity(0.8)
        }
    }
    
    var body: some View {
        ZStack {
//            Rectangle()
//                .fill(Color.blue)

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
            Arc(isDisplaying: true, isSelected: false, onTap: {})
            Arc(isDisplaying: false, isSelected: true, onTap: {})
        }
    }
}
