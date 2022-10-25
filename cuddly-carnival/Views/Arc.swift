import SwiftUI

struct Arc: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addArc(
                center: CGPoint(x: rect.size.width / 2, y: rect.size.width * (3/4)),
                radius: rect.size.width / 2,
                startAngle: .degrees(-40),
                endAngle: .degrees(220),
                clockwise: true
            )
        }
    }
}
