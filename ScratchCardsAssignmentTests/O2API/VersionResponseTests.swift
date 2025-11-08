import Testing
import Foundation
@testable import ScratchCardsAssignment

struct VersionResponseTests {

    @Test func versionResponse_shouldBeDecodable() throws {
        let json = """
        {
            "ios": "7.0"
        }
        """
        let data = json.data(using: .utf8)!

        let response = try JSONDecoder().decode(VersionResponse.self, from: data)

        #expect(response.ios == "7.0")
    }

    @Test func versionResponse_withDifferentVersion_shouldDecodeCorrectly() throws {
        let json = """
        {
            "ios": "10.5.3"
        }
        """
        let data = json.data(using: .utf8)!

        let response = try JSONDecoder().decode(VersionResponse.self, from: data)

        #expect(response.ios == "10.5.3")
    }

    @Test func versionResponse_shouldBeEncodable() throws {
        let response = VersionResponse(ios: "8.0")

        let data = try JSONEncoder().encode(response)
        let decoded = try JSONDecoder().decode(VersionResponse.self, from: data)

        #expect(decoded.ios == "8.0")
    }

    @Test func versionResponse_withMissingField_shouldThrowError() {
        let json = """
        {
            "android": "7.0"
        }
        """
        let data = json.data(using: .utf8)!

        #expect(throws: Error.self) {
            try JSONDecoder().decode(VersionResponse.self, from: data)
        }
    }

    @Test func versionResponse_withExtraFields_shouldIgnoreThem() throws {
        let json = """
        {
            "ios": "6.5",
            "android": "7.0",
            "web": "1.2.3"
        }
        """
        let data = json.data(using: .utf8)!

        let response = try JSONDecoder().decode(VersionResponse.self, from: data)

        #expect(response.ios == "6.5")
    }

    @Test func versionResponse_roundTrip_shouldPreserveData() throws {
        let original = VersionResponse(ios: "9.3.1")

        let encoded = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(VersionResponse.self, from: encoded)

        #expect(decoded.ios == original.ios)
    }
}
