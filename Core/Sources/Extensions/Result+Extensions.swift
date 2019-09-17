import Combine

public func toPublisher<T, E: Error>(_ result: Result<T, E>) -> AnyPublisher<T, E> {
    fatalError()
}
