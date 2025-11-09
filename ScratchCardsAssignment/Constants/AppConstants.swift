import Foundation
import CoreGraphics

enum AppConstants {
    enum Animation {
        static let scratchDurationNanoseconds: UInt64 = 2_000_000_000
    }

    enum Layout {
        static let cardMaxWidth: CGFloat = 400
        static let cardWidthPercentage: CGFloat = 0.9
        static let cardMaxHeight: CGFloat = 250
        static let cardHeightPercentage: CGFloat = 0.8
        static let cardCornerRadius: CGFloat = 20
        static let cardShadowRadius: CGFloat = 10
        static let buttonCornerRadius: CGFloat = 10
    }
}
