//
//  Models.swift
//  Compound
//
//  Created by Vikranth Kumar on 2/23/25.
//

import Foundation

typealias Advisors = [Advisor]
typealias Accounts = [Account]
typealias Holdings = [Holding]

struct Advisor: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let totalAssets: Double
    let custodians: [Custodian]
    
    struct Custodian: Codable, Identifiable, Hashable {
        let id = UUID()
        let repId: String
        let name: String
    }
}

struct Account: Codable, Identifiable, Hashable {
    let id = UUID()
    let name: String
    let number: String
    let repId: String
    let holdingsCount: Int
    let custodian: String
    let totalValue: Double
}

struct Holding: Codable, Identifiable, Hashable {
    let id = UUID()
    let ticker: String
    let units: Int
    let unitPrice: Double
    let name: String
}
