import Foundation
import Functional
import Combine
import Core
import StravaCore

struct AppEnvironment {

    private static var stack: [Environment] = [Environment()]
    
    public static var current: Environment! {
        return stack.last!
    }
}

public struct Environment {
    
    let user: User?
    let connectable: Connectable
    let stravaURLCode: PassthroughSubject<StravaCode?, Never>
    let userStorage: UserStorageProtocol
    
    init(_ user: User? = nil,
         connectable: Connectable = makeConfiguration() |> URLSession.init(configuration:),
         stravaURLCode: PassthroughSubject<StravaCode?, Never> = PassthroughSubject(),
         userStorage: UserStorageProtocol = UserStorage()) {
        self.user = user
        self.connectable = connectable
        self.stravaURLCode = stravaURLCode
        self.userStorage = userStorage
    }
}


private func makeConfiguration() -> URLSessionConfiguration  {
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = [
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Content-Encoding": "gzip"
    ]
    
    return configuration
}
