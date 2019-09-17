import Foundation

public struct StravaAthlete: Equatable, Codable {
    public let id: Int
    public let city: String
    public let country: String
    public let firstname: String
    public let lastname: String
    public let username: String
    public let profile: URL
}
