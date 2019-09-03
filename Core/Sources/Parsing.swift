import Foundation

func encode<T: Encodable>(_ value: T,
                          keyStrategy: JSONEncoder.KeyEncodingStrategy = .convertToSnakeCase
) -> Result<Data, Error> {
    
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = keyStrategy
    
    do {
        let data = try encoder.encode(value)
        return .success(data)
    }
    catch {
        return .failure(error)
    }
}

func decode<T: Decodable>(_ data: Data,
                          dateStrategy: JSONDecoder.DateDecodingStrategy = .iso8601,
                          keyStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase
) -> Result<T, Error> {
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = dateStrategy
    decoder.keyDecodingStrategy = keyStrategy
    
    do {
        let value = try decoder.decode(T.self, from: data)
        return .success(value)
    }
    catch {
        return .failure(error)
    }
}
