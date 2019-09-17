import Overture
import Foundation
import Combine
import Core
import Functional

public protocol StravaAuthenticationBusinessControllerProtocol {
    func makeAuthenticationStep1() -> URLRequest
    func makeAuthenticationStep2(with code: String
        ) -> AnyPublisher<StravaAPIAuthenticationResponse, CoreError>
    func athlete(with token: String
        ) -> AnyPublisher<StravaAthlete, CoreError>
}

public struct StravaAuthenticationBusinessController: StravaAuthenticationBusinessControllerProtocol {
    
    private let connectable: Connectable
    private let configuration: StravaConfiguration
    private let queue = DispatchQueue(label: "queue.authentication", qos: .userInitiated)
    
    public init(connectable: Connectable,
                configuration: StravaConfiguration = StravaConfiguration()) {
        self.connectable = connectable
        self.configuration = configuration
    }
    
    public func makeAuthenticationStep1() -> URLRequest {
        let query: [String: String] = ["response_type": "code",
                                     "client_id": String(describing: configuration.clientId),
                                     "redirect_uri": configuration.redirectURI]
        
        let resource = Resource(path: "authorize", method: .GET, query: query)
        return StravaBackendResolver.makeRequest(backend: .AUTH, resource: resource)
    }
    
    public func makeAuthenticationStep2(with code: String
        ) -> AnyPublisher<StravaAPIAuthenticationResponse, CoreError> {
        
        let request = StravaAPIAuthenticationRequest(code: code,
                                                     clientId: configuration.clientId,
                                                     clientSecret: configuration.clientSecret)
        
        let toResource = curry(Resource.init)("token")(.POST)
        let toRequest = curry(StravaBackendResolver.makeRequest(backend:resource:))(.AUTH)
        let dataToRequest = toResource >>> toRequest
        
        return encode(request)
            .publisher
            .map(dataToRequest)
            .flatMap(maxPublishers: .max(1), connectable.request)
            .map(first)
            .flatMap(maxPublishers: .max(1), decode >>> toPublisher)
            .subscribe(on: queue)
            .eraseToAnyPublisher()
    }
    
    public func athlete(with token: String) -> AnyPublisher<StravaAthlete, CoreError> {
        let request = StravaBackendResolver.APIPath.athlete.resource
            |> curry(StravaBackendResolver.injectAuthenticationHeader)(token)
            |> curry(StravaBackendResolver.makeRequest)(.API)

        return connectable.request(request)
            .map(first)
            .flatMap(maxPublishers: .max(1), decode >>> toPublisher)
            .subscribe(on: queue)
            .eraseToAnyPublisher()
    }
}

