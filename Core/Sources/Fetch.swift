import Foundation
import Combine
import Functional

func fetch<T: Decodable>(_ connectable: Connectable,
                         request: URLRequest
) -> AnyPublisher<T, CoreError> {
    return connectable.request(request)
        .flatMap(first >>> decode >>> Result.Publisher.init)
        .eraseToAnyPublisher()
}
