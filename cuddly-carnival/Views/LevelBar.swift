import SwiftUI

struct LevelBar: View {
    var level: Double
    var label: String

    var body: some View {
        ZStack {
            GeometryReader { geometryReader in
                Rectangle()
                    .fill(
                        LinearGradient(colors: [.red, .green], startPoint: .topLeading, endPoint: .bottomLeading)
                    )

                Rectangle()
                    .frame(
                        height: self.progress(
                            value: self.level,
                            maxValue: 100,
                            height: geometryReader.size.height
                        )
                    )
                    .foregroundColor(.gray)
                    .animation(.easeOut)

                Rectangle()
                    .border(.black)
                    .foregroundColor(.clear)

            }
        }.padding()
    }

    private func progress(
        value: Double,
        maxValue: Double,
        height: CGFloat
    ) -> CGFloat {
        let percentage = value / maxValue
        return height - (height *  CGFloat(percentage))
    }
}