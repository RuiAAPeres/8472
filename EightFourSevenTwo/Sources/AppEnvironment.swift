import Foundation
import Core
import StravaCore

struct AppEnvironment {
    
    public static var current: Environment {
        fatalError()
    }
}

public struct Environment {

    let connectable: Connectable
    let user: User?
    
    init(_ user: User? = nil) {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Content-Encoding": "gzip"
        ]
        
        let session = URLSession(configuration: configuration)
        
        self.connectable = session
        self.user = user
    }
}

