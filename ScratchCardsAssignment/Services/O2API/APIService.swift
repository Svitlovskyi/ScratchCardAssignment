import Foundation

protocol APIServiceProtocol {
    func activateCard(code: String) async throws -> Bool
}

class APIService: APIServiceProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func activateCard(code: String) async throws -> Bool {
        let endpoint = O2VersionEndpoint(code: code)

        do {
            let response: VersionResponse = try await networkService.request(endpoint)
            let isValid = compareVersion(response.ios, isGreaterThan: "6.1")

            if !isValid {
                throw ActivationError.versionTooLow(response.ios)
            }

            return true
        } catch let error as NetworkError {
            throw ActivationError.networkError(error)
        }
    }

    private func compareVersion(_ version: String, isGreaterThan requiredVersion: String) -> Bool {
        return version.compare(requiredVersion, options: .numeric) == .orderedDescending
    }
}
