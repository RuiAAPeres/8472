import Foundation
import Combine

public protocol Connectable {
    func request(_ request: URLRequest) -> AnyPublisher<(Data, URLResponse), URLError>
}

extension URLSession: Connectable {
    public func request(_ request: URLRequest) -> AnyPublisher<(Data, URLResponse), URLError> {
        self.dataTaskPublisher(for: request)
            .map { ($0.data, $0.response) }
            .eraseToAnyPublisher()
    }
}

public class Mock_Connectable: Connectable {

    private let value: Result<(Data, URLResponse), URLError>
    
    public init(value: Result<(Data, URLResponse), URLError>) {
        self.value = value
    }
    
    public func request(_ request: URLRequest) -> AnyPublisher<(Data, URLResponse), URLError> {
        return value.publisher.eraseToAnyPublisher()
    }
}
