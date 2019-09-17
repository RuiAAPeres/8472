import Foundation

public struct User: Equatable, Codable {
    public let athlete: StravaAthlete
    public let accessToken: String
}

extension User {
    public static func make_stub() -> User {
        let athlete = StravaAthlete(id: 0,
                                    city: "Porto",
                                    country: "Portugal",
                                    firstname: "Rui",
                                    lastname: "Peres",
                                    username: "rperes",
                                    profile: URL(string: "www.strava.com/rperes")!)

        let token = "1234567890abcdefghijklmnopr"

        return User(athlete: athlete, accessToken: token)
    }
}
