import Testing
import Foundation
@testable import ScratchCardsAssignment

struct O2VersionEndpointTests {
    typealias Constants = O2VersionEndpointTestConstants

    @Test func baseURL_shouldReturnCorrectO2APIURL() {
        let endpoint = O2VersionEndpoint(code: Constants.testCode)

        #expect(endpoint.baseURL == Constants.API.baseURL)
    }

    @Test func path_shouldReturnVersionPath() {
        let endpoint = O2VersionEndpoint(code: Constants.testCode)

        #expect(endpoint.path == Constants.API.versionPath)
    }

    @Test func method_shouldBeGET() {
        let endpoint = O2VersionEndpoint(code: Constants.testCode)

        #expect(endpoint.method == .get)
    }

    @Test func queryItems_shouldContainCodeParameter() {
        let endpoint = O2VersionEndpoint(code: Constants.testCode1)

        #expect(endpoint.queryItems?.count == 1)
        #expect(endpoint.queryItems?.first?.name == Constants.API.codeParameterName)
        #expect(endpoint.queryItems?.first?.value == Constants.testCode1)
    }

    @Test func buildURL_shouldConstructCorrectURLWithCodeParameter() throws {
        let endpoint = O2VersionEndpoint(code: Constants.testCode123)

        let url = try endpoint.buildURL()

        #expect(url.absoluteString.contains(Constants.API.baseURL + Constants.API.versionPath))
        #expect(url.absoluteString.contains("\(Constants.API.codeParameterName)=\(Constants.testCode123)"))
    }

    @Test func buildURL_withSpecialCharactersInCode_shouldEncodeCorrectly() throws {
        let endpoint = O2VersionEndpoint(code: Constants.specialCharCode)

        let url = try endpoint.buildURL()

        #expect(url.absoluteString.contains("\(Constants.API.codeParameterName)="))
    }

    @Test func headers_shouldReturnNilByDefault() {
        let endpoint = O2VersionEndpoint(code: Constants.testCode)

        #expect(endpoint.headers == nil)
    }

    @Test func endpoint_shouldConformToEndpointProtocol() {
        let endpoint = O2VersionEndpoint(code: Constants.testCode)

        let _: Endpoint = endpoint
    }
}
