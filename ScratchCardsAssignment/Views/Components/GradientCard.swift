import SwiftUI

struct GradientCard<Content: View>: View {
    let gradientColors: [Color]
    let content: Content

    init(gradientColors: [Color], @ViewBuilder content: () -> Content) {
        self.gradientColors = gradientColors
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: AppConstants.Layout.cardCornerRadius)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: gradientColors),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(radius: AppConstants.Layout.cardShadowRadius)

                content
                    .padding()
            }
            .frame(
                width: min(geometry.size.width * AppConstants.Layout.cardWidthPercentage, AppConstants.Layout.cardMaxWidth),
                height: min(geometry.size.height * AppConstants.Layout.cardHeightPercentage, AppConstants.Layout.cardMaxHeight)
            )
            .frame(maxWidth: .infinity)
        }
        .frame(height: AppConstants.Layout.cardMaxHeight)
    }
}
