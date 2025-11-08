import Foundation

enum ActivationError: Error, Equatable {
    case versionTooLow(String)
    case networkError(NetworkError)

    var localizedDescription: String {
        switch self {
        case .versionTooLow(let version):
            return "Version \(version) is too low. Minimum required: 6.1"
        case .networkError(let error):
            return error.localizedDescription
        }
    }
}
