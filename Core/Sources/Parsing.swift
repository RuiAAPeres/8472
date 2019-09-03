import Foundation

func encode<T: Encodable>(_ value: T,
                          strategy: JSONEncoder.KeyEncodingStrategy = .convertToSnakeCase
) -> Result<Data, Error> {
    
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = strategy
    
    fatalError()
}

func decode<T: Decodable>(_ data: Data
) -> Result<T, Error> {
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    fatalError()
}
