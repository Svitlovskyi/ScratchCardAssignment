import Testing
import Foundation
@testable import ScratchCardsAssignment

struct ActivateCardUseCaseTests {
    typealias Constants = ActivateCardUseCaseTestConstants

    @Test func execute_withSuccessfulActivation_shouldReturnSuccess() async {
        let mockAPIService = MockAPIService()
        mockAPIService.activateCardResult = true
        let useCase = ActivateCardUseCase(apiService: mockAPIService)

        let result = await useCase.execute(code: Constants.testCode)

        #expect(mockAPIService.activateCardCalled == true)

        switch result {
        case .success:
            break
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }

    @Test func execute_withVersionTooLowError_shouldReturnVersionNotSupportedError() async {
        let mockAPIService = MockAPIService()
        mockAPIService.shouldThrowError = true
        mockAPIService.errorToThrow = ActivationError.versionTooLow(Constants.Versions.unsupportedVersion)
        let useCase = ActivateCardUseCase(apiService: mockAPIService)

        let result = await useCase.execute(code: Constants.testCode)

        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .versionNotSupported(Constants.Versions.unsupportedVersion))
        }
    }

    @Test func execute_withNetworkError_shouldReturnNetworkFailureError() async {
        let mockAPIService = MockAPIService()
        mockAPIService.shouldThrowError = true
        mockAPIService.errorToThrow = ActivationError.networkError(.requestFailed(Constants.ErrorMessages.connectionLost))
        let useCase = ActivateCardUseCase(apiService: mockAPIService)

        let result = await useCase.execute(code: Constants.testCode)

        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            if case .networkFailure(let message) = error {
                #expect(message.contains(Constants.ErrorMessages.connectionLost))
            } else {
                Issue.record("Expected networkFailure error")
            }
        }
    }

    @Test func execute_withInvalidURLError_shouldReturnNetworkFailureError() async {
        let mockAPIService = MockAPIService()
        mockAPIService.shouldThrowError = true
        mockAPIService.errorToThrow = ActivationError.networkError(.invalidURL)
        let useCase = ActivateCardUseCase(apiService: mockAPIService)

        let result = await useCase.execute(code: Constants.testCode)

        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            if case .networkFailure(let message) = error {
                #expect(message == Constants.ErrorMessages.invalidURL)
            } else {
                Issue.record("Expected networkFailure error")
            }
        }
    }

    @Test func execute_withDecodingError_shouldReturnNetworkFailureError() async {
        let mockAPIService = MockAPIService()
        mockAPIService.shouldThrowError = true
        mockAPIService.errorToThrow = ActivationError.networkError(.decodingError)
        let useCase = ActivateCardUseCase(apiService: mockAPIService)

        let result = await useCase.execute(code: Constants.testCode)

        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            if case .networkFailure(let message) = error {
                #expect(message == Constants.ErrorMessages.decodingError)
            } else {
                Issue.record("Expected networkFailure error")
            }
        }
    }

    @Test func execute_withUnknownError_shouldReturnUnknownError() async {
        struct CustomError: Error {}

        let mockAPIService = MockAPIService()
        mockAPIService.shouldThrowError = true
        mockAPIService.errorToThrow = CustomError()
        let useCase = ActivateCardUseCase(apiService: mockAPIService)

        let result = await useCase.execute(code: Constants.testCode)

        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            if case .unknown = error {
                break
            } else {
                Issue.record("Expected unknown error")
            }
        }
    }

    @Test func versionNotSupportedError_shouldHaveUserFriendlyMessage() {
        let error = ActivationUseCaseError.versionNotSupported(Constants.Versions.unsupportedVersion)

        #expect(error.localizedDescription.contains(Constants.Versions.unsupportedVersion))
        #expect(error.localizedDescription.contains("not supported"))
        #expect(error.localizedDescription.contains(Constants.UseCaseErrorMessages.requiredVersion))
    }

    @Test func networkFailureError_shouldIncludeOriginalMessage() {
        let error = ActivationUseCaseError.networkFailure(Constants.ErrorMessages.timeout)

        #expect(error.localizedDescription.contains(Constants.ErrorMessages.timeout))
        #expect(error.localizedDescription.contains("Network error"))
    }

    @Test func unknownError_shouldIncludeOriginalMessage() {
        let error = ActivationUseCaseError.unknown(Constants.ErrorMessages.somethingWentWrong)

        #expect(error.localizedDescription.contains(Constants.ErrorMessages.somethingWentWrong))
    }

    @Test func activationUseCaseErrors_shouldBeEquatable() {
        let error1 = ActivationUseCaseError.versionNotSupported(Constants.Versions.unsupportedVersion)
        let error2 = ActivationUseCaseError.versionNotSupported(Constants.Versions.unsupportedVersion)

        #expect(error1 == error2)
    }

    @Test func activationUseCaseErrors_withDifferentValues_shouldNotBeEqual() {
        let error1 = ActivationUseCaseError.versionNotSupported(Constants.Versions.unsupportedVersion)
        let error2 = ActivationUseCaseError.versionNotSupported(Constants.Versions.anotherUnsupportedVersion)

        #expect(error1 != error2)
    }

    @Test func activationUseCaseErrors_withDifferentTypes_shouldNotBeEqual() {
        let error1 = ActivationUseCaseError.versionNotSupported(Constants.Versions.unsupportedVersion)
        let error2 = ActivationUseCaseError.networkFailure("Error")

        #expect(error1 != error2)
    }
}
