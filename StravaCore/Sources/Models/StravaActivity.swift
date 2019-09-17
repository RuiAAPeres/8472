import Foundation

public struct StravaActivity: Equatable, Codable {
    let id: Int64
    let name: String
    let description: String?
    let type: String
    let distance: Double
    let averageSpeed: Double
    let movingTime: Double
    let elapsedTime: Double
    let calories: Double?
    let averageHeartrate: Double?
    let totalElevationGain: Double
    let averageCadence: Double
    let startDate: Date
    let maxSpeed: Double
}

extension Array where Element == StravaActivity {
    static func orderByDate(_ array: Array) -> Array {
        return array.sorted(by: { lhs, rhs in
            lhs.startDate > rhs.startDate
        })
    }
}
