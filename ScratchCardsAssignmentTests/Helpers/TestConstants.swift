import Foundation

enum APIServiceTestConstants {
    static let testCode = "ABC123XYZ"
    static let genericTestCode = "test-code"

    enum Versions {
        static let validMedium = "6.2"
        static let validHigh = "7.0"
        static let validVeryHigh = "10.5.3"
        static let validExtreme = "15.0"
        static let edgeCase = "6.10"
        static let exactMinimum = "6.1"
        static let justBelow = "6.0"
        static let low = "5.9"
        static let veryLow = "1.0"
    }

    enum ErrorMessages {
        static let connectionLost = "Connection lost"
    }

    enum CodeArray {
        static let multiple = ["code1", "code2", "UUID-123-456"]
    }
}

enum O2VersionEndpointTestConstants {
    static let testCode = "test-code"
    static let testCode1 = "ABC123"
    static let testCode123 = "test123"
    static let specialCharCode = "test code@123"

    enum API {
        static let baseURL = "https://api.o2.sk"
        static let versionPath = "/version"
        static let codeParameterName = "code"
    }
}

enum ActivateCardUseCaseTestConstants {
    static let testCode = "test-code"

    enum Versions {
        static let unsupportedVersion = "5.0"
        static let anotherUnsupportedVersion = "6.0"
    }

    enum ErrorMessages {
        static let connectionLost = "Connection lost"
        static let somethingWentWrong = "Something went wrong"
        static let invalidURL = "Invalid URL"
        static let decodingError = "Failed to decode response"
        static let timeout = "Connection timeout"
    }

    enum UseCaseErrorMessages {
        static let requiredVersion = "6.2"
    }
}
