import Combine
import Core

public protocol UserStorageProtocol {
    func save(user: User) -> AnyPublisher<User, CoreError>
    func load() -> AnyPublisher<User, CoreError>
}

public struct UserStorage: UserStorageProtocol {
    
    public init() {}
    
    public func save(user: User) -> AnyPublisher<User, CoreError> {
        return Fail(error: CoreError.failedStoringUser).eraseToAnyPublisher()
    }
    public func load() -> AnyPublisher<User, CoreError> {
        return Fail(error: CoreError.userNotFound).eraseToAnyPublisher()
    }
}
