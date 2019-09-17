import Foundation
import Combine

import Overture
import Core
import CombineFeedback
import Functional

public typealias StravaCode = String
public typealias StravaAccessToken = String

protocol SessionViewModelProtocol {
    var state: AnyPublisher<SessionViewModel.State, Never> { get }
}

public final class SessionViewModel: SessionViewModelProtocol {
    
    public let state: AnyPublisher<SessionViewModel.State, Never>
    
    private let queue = DispatchQueue(label: "queue.session", qos: .userInitiated)
    
    public init(
        authentication: StravaAuthenticationBusinessControllerProtocol,
        storage: UserStorage,
        stravaURLCode: PassthroughSubject<StravaCode?, Never>
        ) {
        
        state = Publishers.system(initial: .checkCredentials,
                                  feedbacks: [
                                    SessionViewModel.loop_checkCredentials(authentication: authentication, storage: storage),
                                    SessionViewModel.loop_authenticateStep0(storage: storage, stravaURLCode: stravaURLCode),
                                    SessionViewModel.loop_authenticateStep1(authentication: authentication),
                                    SessionViewModel.loop_authenticateStep2(authentication: authentication, storage: storage)
                                  ],
                                  scheduler: queue,
                                  reduce: SessionViewModel.reducer)
    }
}

extension SessionViewModel {
    static func loop_checkCredentials(authentication: StravaAuthenticationBusinessControllerProtocol,
                                      storage: UserStorage
        ) -> Feedback<State, Event> {
        
        return Feedback(effects: { state -> AnyPublisher<Event, Never> in
            
            guard case .checkCredentials = state else {
                return Empty().eraseToAnyPublisher()
            }
            
            let refreshUser: (User) -> AnyPublisher<User, CoreError> = { user in
                return authentication.athlete(with: user.accessToken)
                    .map { athlete in User(athlete: athlete, accessToken: user.accessToken) }
                    .eraseToAnyPublisher()
            }
            
            let save: (User) -> AnyPublisher<User, CoreError> = { user in
                return storage.save(user: user)
            }
            
            return storage.load()
                .flatMap(maxPublishers: .max(1), refreshUser)
                .flatMap(maxPublishers: .max(1), save)
                .map(Event.authenticated)
                .replaceError(with: Event.noAuthentication)
                .eraseToAnyPublisher()
        })
    }
    
    static func loop_authenticateStep0(storage: UserStorage,
                                       stravaURLCode: PassthroughSubject<StravaCode?, Never>)
        -> Feedback<State, Event> {
            
            return Feedback(effects: { state -> AnyPublisher<Event, Never> in
                
                let empty = Empty<Event, Never>().eraseToAnyPublisher()
                
                return stravaURLCode.flatMapLatest { someCode -> AnyPublisher<Event, Never> in
                    guard case .unauthenticated = state else {
                        return empty
                    }
                    
                    guard let code = someCode else {
                        return empty
                    }
                    
                    return Just(Event.authenticatedStep1(code))
                        .eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
            })
    }
    
    static func loop_authenticateStep1(authentication: StravaAuthenticationBusinessControllerProtocol
        ) -> Feedback<State, Event> {
        return Feedback(effects: { state -> AnyPublisher<Event, Never> in
            
            guard case let .authenticatingStep1(stravaCode) = state else {
                return Empty<Event, Never>().eraseToAnyPublisher()
            }
            
            return authentication
                .makeAuthenticationStep2(with: stravaCode)
                .map(Event.authenticatedStep2)
                .catch(Event.failedStep1 >>> Just.init)
                .eraseToAnyPublisher()
        })
    }
    
    static func loop_authenticateStep2(authentication: StravaAuthenticationBusinessControllerProtocol,
                                       storage: UserStorage
        ) -> Feedback<State, Event> {
        return Feedback(effects: { state -> AnyPublisher<Event, Never> in
            
            guard case let .authenticatingStep2(response) = state else {
                return Empty<Event, Never>().eraseToAnyPublisher()
            }
            /// accessToken    StravaAccessToken    "76343ada89b572b20f8fab7a7904ac7d7fdc3b9d"
            let toUser: (StravaAthlete) -> User = { athlete in
                return User(athlete: athlete, accessToken: response.accessToken)
            }
            
            let saveUser: (User) -> AnyPublisher<User, CoreError> = { user in
                return storage.save(user: user)
            }
            
            return authentication.athlete(with: response.accessToken)
                .map(toUser)
                .flatMap(maxPublishers: .max(1), saveUser)
                .map(Event.authenticated)
                .catch(Event.failedStep2 >>> Just.init)
                .eraseToAnyPublisher()
        })
    }
}


extension SessionViewModel {
    public enum State: Equatable {
        case unauthenticated
        case checkCredentials
        case authenticatingStep1(StravaCode)
        case authenticatingStep2(StravaAPIAuthenticationResponse)
        case authenticated(User)
        case failedStep1(CoreError)
        case failedStep2(CoreError)
    }
    
    enum Event: Equatable {
        case noAuthentication
        case unauthenticated
        case authenticatedStep1(StravaCode)
        case authenticatedStep2(StravaAPIAuthenticationResponse)
        case authenticated(User)
        case failedStep1(CoreError)
        case failedStep2(CoreError)
    }
}

extension SessionViewModel {
    static func reducer(state: State, event: Event) -> State {
        switch(state, event) {
        case (.checkCredentials, .noAuthentication):
            return .unauthenticated
        case let (.checkCredentials, .authenticated(user)):
            return .authenticated(user)
        case let (.unauthenticated, .authenticatedStep1(request)):
            return .authenticatingStep1(request)
        case let (.authenticatingStep1, .authenticatedStep2(code)):
            return .authenticatingStep2(code)
        case let (.authenticatingStep2, .authenticated(user)):
            return .authenticated(user)
            
        default:
            print(state)
            print(event)
            fatalError()
        }
    }
}

public struct UserStorage {
    
    private let path: String
    
    public init(path: String) {
        self.path = path
    }
    
    public func save(user: User) -> AnyPublisher<User, CoreError> {
        return Empty().eraseToAnyPublisher()
    }
    public func load() -> AnyPublisher<User, CoreError> {
        return Empty().eraseToAnyPublisher()
    }
}
