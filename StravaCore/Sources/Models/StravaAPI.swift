public struct StravaAPIAuthenticationRequest: Equatable, Encodable {
    public let code: String
    public let clientId: Int
    public let clientSecret: String
    
    public init(code: String, clientId: Int, clientSecret: String) {
        self.code = code
        self.clientId = clientId
        self.clientSecret = clientSecret
    }
}

public struct StravaAPIAuthenticationResponse: Equatable, Decodable {
    public let accessToken: String
}
