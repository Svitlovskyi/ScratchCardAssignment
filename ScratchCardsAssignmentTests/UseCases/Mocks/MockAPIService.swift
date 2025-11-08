import Foundation
@testable import ScratchCardsAssignment

class MockAPIService: APIServiceProtocol {
    var shouldThrowError = false
    var errorToThrow: Error?
    var activateCardCalled = false
    var activateCardResult: Bool = true
    var capturedCode: String?

    func activateCard(code: String) async throws -> Bool {
        activateCardCalled = true
        capturedCode = code

        if shouldThrowError {
            throw errorToThrow ?? ActivationError.networkError(.requestFailed("Mock error"))
        }

        return activateCardResult
    }

    func reset() {
        shouldThrowError = false
        errorToThrow = nil
        activateCardCalled = false
        activateCardResult = true
        capturedCode = nil
    }
}
