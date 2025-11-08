import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case requestFailed(String)
    case decodingError
    case invalidResponse

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .requestFailed(let message):
            return "Request failed: \(message)"
        case .decodingError:
            return "Failed to decode response"
        case .invalidResponse:
            return "Invalid response"
        }
    }
}
