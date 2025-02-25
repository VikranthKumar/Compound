//
//  NetworkRepository.swift
//  Compound
//
//  Created by Vikranth Kumar on 2/23/25.
//

import Foundation

struct NetworkRepository {
    
    static func getAdvisors() async throws -> Advisors {
        let response = try await NetworkSession.request(with: .getAdvisors)
        return try response.unwrap(NetworkResponse.getAdvisors)
    }
    
    static func getAccounts(advisorId: String) async throws -> Accounts {
        let response = try await NetworkSession.request(with: .getAccounts(advisorId: advisorId))
        return try response.unwrap(NetworkResponse.getAccounts)
    }
    
    static func getHoldings(accountId: String) async throws -> Holdings {
        let response = try await NetworkSession.request(with: .getHoldings(accountId: accountId))
        return try response.unwrap(NetworkResponse.getHoldings)
    }
    
}
