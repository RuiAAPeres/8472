import Foundation

public func extract(key: String, from queryItems: [URLQueryItem]?) -> String? {
    return queryItems?
        .filter { $0.name == key }
        .compactMap { $0.value }
        .first
}
