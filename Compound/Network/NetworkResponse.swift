//
//  NetworkResponse.swift
//  Compound
//
//  Created by Vikranth Kumar on 2/23/25.
//

import Foundation

struct GenericResponse: Codable {
    let message: String
}

enum NetworkResponse {
    case some(request: NetworkRequest, output: (data: Data, response: URLResponse))
    case error(Error)
    
    case getAdvisors(advisors: Advisors)
    case getAccounts(advisors: Accounts)
    case getHoldings(holdings: Holdings)
}

extension NetworkResponse {
    func unwrap<T: Decodable>(_: (T) -> NetworkResponse) throws -> T {
        guard case let .some(_, output) = self else {
            if case let .error(error) = self {
                print("error")
                throw error
            } else {
                print("unknownError")
                throw NetworkError.unknownError
            }
        }
        print(output)
        print(output.response.description)
        guard let httpResponse = output.response as? HTTPURLResponse else {
            print("invalidResponse")
            throw NetworkError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            print("httpError")
            throw NetworkError.httpError(httpResponse.statusCode)
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try decoder.decode(T.self, from: output.data)
            print(decodedData)
            return decodedData
        } catch (let error) {
            print("decodingError \(error.localizedDescription)")
            throw NetworkError.decodingError
        }
    }
}
