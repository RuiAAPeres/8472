import Foundation
import Combine
import Functional

public protocol Connectable {
    func request(_ request: URLRequest) -> AnyPublisher<(Data, URLResponse), CoreError>
}

extension URLSession: Connectable {
    public func request(_ request: URLRequest) -> AnyPublisher<(Data, URLResponse), CoreError> {
        self.dataTaskPublisher(for: request)
            .map { ($0.data, $0.response) }
            .mapError { $0.localizedDescription |> CoreError.network }
            .eraseToAnyPublisher()
    }
}

public class Mock_Connectable: Connectable {

    private let value: Result<(Data, URLResponse), CoreError>
    
    public init(value: Result<(Data, URLResponse), CoreError>) {
        self.value = value
    }
    
    public func request(_ request: URLRequest) -> AnyPublisher<(Data, URLResponse), CoreError> {
        return value.publisher.eraseToAnyPublisher()
    }
}
