import SwiftUI

struct Arc: View {
    private let contentLineWidth: CGFloat = 14
    private let borderLineWidth: CGFloat = 20
    private let borderColor: Color = .gray
    private let arcColor: Color = .white.opacity(0.3)
    
    var body: some View {
        Button(action: {
            print("arc pressed")
        }) {
            ZStack {
//                Rectangle()
//                        .fill(Color.blue)

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
        Arc()
    }
}
