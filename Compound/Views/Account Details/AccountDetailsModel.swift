//
//  AccountDetailsModel.swift
//  Compound
//
//  Created by Vikranth Kumar on 2/24/25.
//

import Foundation

struct AccountDetailsModel {
    
    private(set) var account: Account
    private(set) var holdings: Holdings?
    
    init(account: Account) {
        self.account = account
    }
    
    @MainActor
    mutating func saveHoldings(with newHoldings: Holdings) {
        holdings = newHoldings
    }
}
