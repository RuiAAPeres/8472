import MapKit

public struct StravaStream {
    public let coordinates: [CLLocationCoordinate2D]
    public let distance: [Double]
    public let heartRate: [Double]
    public let altitude: [Double]

    init(rawData: RawStravaStreamResponse) {
        
        var coordinates: [CLLocationCoordinate2D] = []
        var distance: [Double] = []
        var heartRate: [Double] = []
        var altitude: [Double] = []
        
        for item in rawData {
            switch item.type {
            case "distance":
                distance = item.data.map { $0.value! }
            case "heartrate":
                heartRate = item.data.map { $0.value! }
            case "altitude":
                altitude = item.data.map { $0.value! }
            case "latlng":
                coordinates = item.data.map { ($0.values![0], $0.values![1]) }.map(CLLocationCoordinate2D.init(latitude:longitude:))
            default:
                break
            }
        }
        
        self.coordinates = coordinates
        self.distance = distance
        self.heartRate = heartRate
        self.altitude = altitude
    }
}

struct RawResponseElement: Codable {
    let type: String
    let data: [Datum]
}

enum Datum: Codable {
    case double(Double)
    case doubleArray([Double])
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([Double].self) {
            self = .doubleArray(x)
            return
        }
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        throw DecodingError.typeMismatch(Datum.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Datum"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let x):
            try container.encode(x)
        case .doubleArray(let x):
            try container.encode(x)
        }
    }
    
    var value: Double? {
        switch self {
        case .double(let value):
            return value
        default:
            return nil
        }
    }
    
    var values: [Double]? {
        switch self {
        case .doubleArray(let value):
            return value
        default:
            return nil
        }
    }
}

typealias RawStravaStreamResponse = [RawResponseElement]
