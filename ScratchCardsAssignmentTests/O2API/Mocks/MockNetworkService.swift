import Foundation
@testable import ScratchCardsAssignment

class MockNetworkService: NetworkServiceProtocol {
    var shouldThrowError = false
    var errorToThrow: Error?
    var mockResponse: Any?
    var capturedEndpoint: Endpoint?

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        capturedEndpoint = endpoint

        if shouldThrowError {
            throw errorToThrow ?? NetworkError.requestFailed("Mock error")
        }

        guard let response = mockResponse as? T else {
            throw NetworkError.decodingError
        }

        return response
    }

    func reset() {
        shouldThrowError = false
        errorToThrow = nil
        mockResponse = nil
        capturedEndpoint = nil
    }
}
