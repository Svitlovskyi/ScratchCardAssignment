import Foundation

enum ScratchCardState: Equatable {
    case unscratched
    case scratched(code: String)
    case activated(code: String)

    var description: String {
        switch self {
        case .unscratched:
            return "Unscratched"
        case .scratched(let code):
            return "Scratched - Code: \(code)"
        case .activated(let code):
            return "Activated - Code: \(code)"
        }
    }

    var code: String? {
        switch self {
        case .scratched(let code), .activated(let code):
            return code
        case .unscratched:
            return nil
        }
    }

    var canBeScratched: Bool {
        if case .unscratched = self {
            return true
        }
        return false
    }

    var canBeActivated: Bool {
        if case .scratched = self {
            return true
        }
        return false
    }
}
