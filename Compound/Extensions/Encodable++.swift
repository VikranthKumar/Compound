//
//  Encodable.swift
//  Compound
//
//  Created by Vikranth Kumar on 2/23/25.
//

import Foundation

extension Encodable {
    func toJSONData(prettyPrint: Bool = false) throws -> Data {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = prettyPrint ? [.sortedKeys, .prettyPrinted] : [.sortedKeys]
        return try encoder.encode(self)
    }
}
