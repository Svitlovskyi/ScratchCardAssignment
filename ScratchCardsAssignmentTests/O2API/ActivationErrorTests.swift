import Testing
@testable import ScratchCardsAssignment

struct ActivationErrorTests {

    @Test func versionTooLow_shouldHaveCorrectDescription() {
        let error = ActivationError.versionTooLow("5.0")

        #expect(error.localizedDescription == "Version 5.0 is too low. Minimum required: 6.1")
    }

    @Test func versionTooLow_withDifferentVersion_shouldIncludeVersionInDescription() {
        let error = ActivationError.versionTooLow("6.0")

        #expect(error.localizedDescription == "Version 6.0 is too low. Minimum required: 6.1")
    }

    @Test func versionTooLow_withVersion1_0_shouldHaveCorrectDescription() {
        let error = ActivationError.versionTooLow("1.0")

        #expect(error.localizedDescription == "Version 1.0 is too low. Minimum required: 6.1")
    }

    @Test func networkError_withInvalidURL_shouldReturnNetworkErrorDescription() {
        let networkError = NetworkError.invalidURL
        let error = ActivationError.networkError(networkError)

        #expect(error.localizedDescription == "Invalid URL")
    }

    @Test func networkError_withRequestFailed_shouldReturnNetworkErrorDescription() {
        let networkError = NetworkError.requestFailed("Connection timeout")
        let error = ActivationError.networkError(networkError)

        #expect(error.localizedDescription == "Request failed: Connection timeout")
    }

    @Test func networkError_withDecodingError_shouldReturnNetworkErrorDescription() {
        let networkError = NetworkError.decodingError
        let error = ActivationError.networkError(networkError)

        #expect(error.localizedDescription == "Failed to decode response")
    }

    @Test func networkError_withInvalidResponse_shouldReturnNetworkErrorDescription() {
        let networkError = NetworkError.invalidResponse
        let error = ActivationError.networkError(networkError)

        #expect(error.localizedDescription == "Invalid response")
    }

    @Test func activationErrors_shouldBeEquatable() {
        let error1 = ActivationError.versionTooLow("5.0")
        let error2 = ActivationError.versionTooLow("5.0")

        #expect(error1 == error2)
    }

    @Test func activationErrors_withDifferentVersions_shouldNotBeEqual() {
        let error1 = ActivationError.versionTooLow("5.0")
        let error2 = ActivationError.versionTooLow("6.0")

        #expect(error1 != error2)
    }

    @Test func activationErrors_withDifferentTypes_shouldNotBeEqual() {
        let error1 = ActivationError.versionTooLow("5.0")
        let error2 = ActivationError.networkError(NetworkError.invalidURL)

        #expect(error1 != error2)
    }

    @Test func networkErrors_withSameNetworkError_shouldBeEqual() {
        let error1 = ActivationError.networkError(NetworkError.invalidURL)
        let error2 = ActivationError.networkError(NetworkError.invalidURL)

        #expect(error1 == error2)
    }

    @Test func networkErrors_withDifferentNetworkErrors_shouldNotBeEqual() {
        let error1 = ActivationError.networkError(NetworkError.invalidURL)
        let error2 = ActivationError.networkError(NetworkError.decodingError)

        #expect(error1 != error2)
    }

    @Test func networkErrors_withRequestFailed_shouldCompareMessages() {
        let error1 = ActivationError.networkError(NetworkError.requestFailed("Timeout"))
        let error2 = ActivationError.networkError(NetworkError.requestFailed("Timeout"))

        #expect(error1 == error2)
    }

    @Test func networkErrors_withDifferentRequestFailedMessages_shouldNotBeEqual() {
        let error1 = ActivationError.networkError(NetworkError.requestFailed("Timeout"))
        let error2 = ActivationError.networkError(NetworkError.requestFailed("Not found"))

        #expect(error1 != error2)
    }
}
