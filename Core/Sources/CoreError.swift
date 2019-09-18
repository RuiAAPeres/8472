public enum CoreError: Error, Equatable {
    case network(String)
    case parser(String)
    case userNotFound
    case failedStoringUser
}
