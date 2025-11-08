import Testing
import Foundation
@testable import ScratchCardsAssignment

struct APIServiceTests {
    typealias Constants = APIServiceTestConstants

    @Test func activateCard_withValidVersionAbove6_1_shouldReturnTrue() async throws {
        let mockNetworkService = MockNetworkService()
        mockNetworkService.mockResponse = VersionResponse(ios: Constants.Versions.validMedium)
        let apiService = APIService(networkService: mockNetworkService)

        let result = try await apiService.activateCard(code: Constants.testCode)

        #expect(result == true)
    }

    @Test func activateCard_withVersion7_0_shouldReturnTrue() async throws {
        let mockNetworkService = MockNetworkService()
        mockNetworkService.mockResponse = VersionResponse(ios: Constants.Versions.validHigh)
        let apiService = APIService(networkService: mockNetworkService)

        let result = try await apiService.activateCard(code: Constants.testCode)

        #expect(result == true)
    }

    @Test func activateCard_withVersion10_5_3_shouldReturnTrue() async throws {
        let mockNetworkService = MockNetworkService()
        mockNetworkService.mockResponse = VersionResponse(ios: Constants.Versions.validVeryHigh)
        let apiService = APIService(networkService: mockNetworkService)

        let result = try await apiService.activateCard(code: Constants.testCode)

        #expect(result == true)
    }

    @Test func activateCard_withVersionExactly6_1_shouldThrowVersionTooLowError() async throws {
        let mockNetworkService = MockNetworkService()
        mockNetworkService.mockResponse = VersionResponse(ios: Constants.Versions.exactMinimum)
        let apiService = APIService(networkService: mockNetworkService)

        await #expect(throws: ActivationError.versionTooLow(Constants.Versions.exactMinimum)) {
            try await apiService.activateCard(code: Constants.testCode)
        }
    }

    @Test func activateCard_withVersionBelow6_1_shouldThrowVersionTooLowError() async throws {
        let mockNetworkService = MockNetworkService()
        mockNetworkService.mockResponse = VersionResponse(ios: Constants.Versions.justBelow)
        let apiService = APIService(networkService: mockNetworkService)

        await #expect(throws: ActivationError.versionTooLow(Constants.Versions.justBelow)) {
            try await apiService.activateCard(code: Constants.testCode)
        }
    }

    @Test func activateCard_withVersion5_9_shouldThrowVersionTooLowError() async throws {
        let mockNetworkService = MockNetworkService()
        mockNetworkService.mockResponse = VersionResponse(ios: Constants.Versions.low)
        let apiService = APIService(networkService: mockNetworkService)

        await #expect(throws: ActivationError.versionTooLow(Constants.Versions.low)) {
            try await apiService.activateCard(code: Constants.testCode)
        }
    }

    @Test func activateCard_withVersion1_0_shouldThrowVersionTooLowError() async throws {
        let mockNetworkService = MockNetworkService()
        mockNetworkService.mockResponse = VersionResponse(ios: Constants.Versions.veryLow)
        let apiService = APIService(networkService: mockNetworkService)

        await #expect(throws: ActivationError.versionTooLow(Constants.Versions.veryLow)) {
            try await apiService.activateCard(code: Constants.testCode)
        }
    }

    @Test func activateCard_withNetworkError_shouldThrowActivationErrorWithNetworkError() async throws {
        let mockNetworkService = MockNetworkService()
        mockNetworkService.shouldThrowError = true
        mockNetworkService.errorToThrow = NetworkError.requestFailed(Constants.ErrorMessages.connectionLost)
        let apiService = APIService(networkService: mockNetworkService)

        await #expect(throws: ActivationError.networkError(NetworkError.requestFailed(Constants.ErrorMessages.connectionLost))) {
            try await apiService.activateCard(code: Constants.genericTestCode)
        }
    }

    @Test func activateCard_withInvalidURL_shouldThrowActivationErrorWithNetworkError() async throws {
        let mockNetworkService = MockNetworkService()
        mockNetworkService.shouldThrowError = true
        mockNetworkService.errorToThrow = NetworkError.invalidURL
        let apiService = APIService(networkService: mockNetworkService)

        await #expect(throws: ActivationError.networkError(NetworkError.invalidURL)) {
            try await apiService.activateCard(code: Constants.genericTestCode)
        }
    }

    @Test func activateCard_withDecodingError_shouldThrowActivationErrorWithNetworkError() async throws {
        let mockNetworkService = MockNetworkService()
        mockNetworkService.shouldThrowError = true
        mockNetworkService.errorToThrow = NetworkError.decodingError
        let apiService = APIService(networkService: mockNetworkService)

        await #expect(throws: ActivationError.networkError(NetworkError.decodingError)) {
            try await apiService.activateCard(code: Constants.genericTestCode)
        }
    }

    @Test func activateCard_shouldCallNetworkServiceWithO2VersionEndpoint() async throws {
        let mockNetworkService = MockNetworkService()
        mockNetworkService.mockResponse = VersionResponse(ios: Constants.Versions.validHigh)
        let apiService = APIService(networkService: mockNetworkService)

        _ = try await apiService.activateCard(code: Constants.testCode)

        #expect(mockNetworkService.capturedEndpoint != nil)
        #expect(mockNetworkService.capturedEndpoint is O2VersionEndpoint)

        if let endpoint = mockNetworkService.capturedEndpoint as? O2VersionEndpoint {
            #expect(endpoint.code == Constants.testCode)
        }
    }

    @Test func activateCard_withDifferentCodes_shouldPassCorrectCodeToEndpoint() async throws {
        let mockNetworkService = MockNetworkService()
        mockNetworkService.mockResponse = VersionResponse(ios: Constants.Versions.validHigh)
        let apiService = APIService(networkService: mockNetworkService)

        for testCode in Constants.CodeArray.multiple {
            mockNetworkService.reset()
            mockNetworkService.mockResponse = VersionResponse(ios: Constants.Versions.validHigh)

            _ = try await apiService.activateCard(code: testCode)

            if let endpoint = mockNetworkService.capturedEndpoint as? O2VersionEndpoint {
                #expect(endpoint.code == testCode)
            }
        }
    }

    @Test func activateCard_withEdgeCaseVersion6_2_shouldReturnTrue() async throws {
        let mockNetworkService = MockNetworkService()
        mockNetworkService.mockResponse = VersionResponse(ios: Constants.Versions.validMedium)
        let apiService = APIService(networkService: mockNetworkService)

        let result = try await apiService.activateCard(code: Constants.genericTestCode)

        #expect(result == true)
    }

    @Test func activateCard_withVersion6_10_shouldReturnTrue() async throws {
        let mockNetworkService = MockNetworkService()
        mockNetworkService.mockResponse = VersionResponse(ios: Constants.Versions.edgeCase)
        let apiService = APIService(networkService: mockNetworkService)

        let result = try await apiService.activateCard(code: Constants.genericTestCode)

        #expect(result == true)
    }

    @Test func activateCard_withVersion15_0_shouldReturnTrue() async throws {
        let mockNetworkService = MockNetworkService()
        mockNetworkService.mockResponse = VersionResponse(ios: Constants.Versions.validExtreme)
        let apiService = APIService(networkService: mockNetworkService)

        let result = try await apiService.activateCard(code: Constants.genericTestCode)

        #expect(result == true)
    }
}
