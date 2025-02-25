//
//  AdvisorDetailsViewModel.swift
//  Compound
//
//  Created by Vikranth Kumar on 2/24/25.
//

import Foundation

@Observable class AdvisorDetailsViewModel {
    
    private(set) var model: AdvisorDetailsModel
    
    var didFail = false
    
    init(advisor: Advisor) {
        model = .init(advisor: advisor)
    }
    
    var advisor: Advisor {
        model.advisor
    }
    
    var accounts: Accounts? {
        model.accounts
    }
    
    @MainActor
    func getAccounts() async throws {
        do {
            didFail = false
            let accounts = try await NetworkRepository.getAccounts(advisorId: advisor.id)
            model.saveAccounts(with: accounts)
        } catch {
            didFail = true
        }
    }
    
}
