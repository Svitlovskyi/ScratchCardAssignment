import Foundation

protocol ActivateCardUseCaseProtocol {
    func execute(code: String) async -> Result<Void, ActivationUseCaseError>
}

enum ActivationUseCaseError: Error, Equatable {
    case versionNotSupported(String)
    case networkFailure(String)
    case unknown(String)

    var localizedDescription: String {
        switch self {
        case .versionNotSupported(let version):
            return "Your iOS version \(version) is not supported. Please update to version 6.2 or higher."
        case .networkFailure(let message):
            return "Network error: \(message)"
        case .unknown(let message):
            return "An error occurred: \(message)"
        }
    }
}

class ActivateCardUseCase: ActivateCardUseCaseProtocol {
    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    func execute(code: String) async -> Result<Void, ActivationUseCaseError> {
        do {
            let success = try await apiService.activateCard(code: code)

            if success {
                return .success(())
            } else {
                return .failure(.unknown("Activation failed"))
            }
        } catch let error as ActivationError {
            return .failure(mapActivationError(error))
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }

    private func mapActivationError(_ error: ActivationError) -> ActivationUseCaseError {
        switch error {
        case .versionTooLow(let version):
            return .versionNotSupported(version)
        case .networkError(let networkError):
            return .networkFailure(networkError.localizedDescription)
        }
    }
}
