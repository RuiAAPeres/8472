import Foundation
import Functional

func encode<T: Encodable>(_ value: T) -> Result<Data, CoreError> {
    
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    
    do {
        let data = try encoder.encode(value)
        return .success(data)
    }
    catch {
        return error.localizedDescription |>
            CoreError.parser >>> Result.failure
    }
}

func decode<T: Decodable>(_ data: Data) -> Result<T, CoreError> {
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    do {
        let value = try decoder.decode(T.self, from: data)
        return .success(value)
    }
    catch {
        return error.localizedDescription |>
            CoreError.parser >>> Result.failure
    }
}
