//
//  AdvisorDetailsModel.swift
//  Compound
//
//  Created by Vikranth Kumar on 2/24/25.
//

import Foundation

struct AdvisorDetailsModel {
    
    private(set) var advisor: Advisor
    private(set) var accounts: Accounts?
    
    init(advisor: Advisor) {
        self.advisor = advisor
    }
    
    @MainActor
    mutating func saveAccounts(with newAccounts: Accounts) {
        accounts = newAccounts
    }
}
