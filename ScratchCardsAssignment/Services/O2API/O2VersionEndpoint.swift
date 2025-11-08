import Foundation

struct O2VersionEndpoint: Endpoint {
    let code: String

    var baseURL: String { "https://api.o2.sk" }
    var path: String { "/version" }
    var method: HTTPMethod { .get }
    var queryItems: [URLQueryItem]? {
        [URLQueryItem(name: "code", value: code)]
    }
}
