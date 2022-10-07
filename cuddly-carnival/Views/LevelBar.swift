import SwiftUI

struct LevelBar: View {
    var level: Double
    var label: String

    var body: some View {
        ZStack {
            GeometryReader { geometryReader in
                Rectangle()
                    .fill(
                        LinearGradient(colors: [.red, .yellow, .green], startPoint: .topLeading, endPoint: .bottomLeading)
                    )

                Rectangle()
                    .frame(
                        height: self.progress(
                            value: self.level,
                            maxValue: 100,
                            height: geometryReader.size.height
                        )
                    )
                    .foregroundColor(.white)
                    .animation(.easeOut)

                Rectangle()
                    .border(.black)
                    .foregroundColor(.clear)

            }
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
