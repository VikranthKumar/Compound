//
//  AccountDetailsViewModel.swift
//  Compound
//
//  Created by Vikranth Kumar on 2/24/25.
//

import Foundation

@Observable class AccountDetailsViewModel {
    
    private(set) var model: AccountDetailsModel
    
    var didFail = false
    
    init(account: Account) {
        model = .init(account: account)
    }
    
    var account: Account {
        model.account
    }
    
    var holdings: Holdings? {
        model.holdings
    }
    
    @MainActor
    func getHoldings() async throws {
        do {
            didFail = false
            let holdings = try await NetworkRepository.getHoldings(accountId: "\(account.id)")
            model.saveHoldings(with: holdings)
        } catch {
            didFail = true
        }
    }
    
}
