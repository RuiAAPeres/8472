import Foundation
import Core
import Functional

struct StravaBackendResolver {
    enum Backend: String {
        case API = "https://www.strava.com/api/v3"
        case AUTH = "https://www.strava.com/oauth"
        
        var url: URL {
            return URL(string: self.rawValue)!
        }
    }
    
    enum APIPath: String {
        case authorize = "authorize"
        case athlete = "athlete"
        case activities = "athlete/activities"
        
        var resource: Resource {
            return Resource(path: self.rawValue, method: .GET)
        }
    }
    
    static func makeRequest(backend: Backend = .API, resource: Resource) -> URLRequest {
        return backend.url |> resource.toRequest
    }
    
    static func injectAuthenticationHeader(token: String, resource: Resource) -> Resource {
        let value = "Bearer \(token)"
        return resource.addHeader(value, key: "Authorization")
    }
}

