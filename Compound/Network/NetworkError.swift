//
//  NetworkError.swift
//  Compound
//
//  Created by Vikranth Kumar on 2/23/25.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case httpError(Int)
    case noData
    case decodingError
    case unknownError
}
