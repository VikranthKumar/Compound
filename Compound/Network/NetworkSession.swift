//
//  NetworkSession.swift
//  Compound
//
//  Created by Vikranth Kumar on 2/23/25.
//

import Foundation

class NetworkSession {
    static func request(with request: NetworkRequest) async throws -> NetworkResponse {
        guard let urlRequest = request.buildURLRequest() else {
            throw NetworkError.invalidRequest
        }
        print("Request: \(urlRequest.description)")
        print("Request URL: \(urlRequest.url?.absoluteString ?? "")")
        print("Headers: \(urlRequest.allHTTPHeaderFields ?? [:])")
        if let requestBody = urlRequest.httpBody {
            print("Request Body: \(String(data: requestBody, encoding: .utf8) ?? "")")
        }
        print("Method: \(urlRequest.httpMethod?.description ?? "-")")
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            return .some(request: request, output: (data: data, response: response))
        } catch {
            throw NetworkError.unknownError
        }
    }
}
