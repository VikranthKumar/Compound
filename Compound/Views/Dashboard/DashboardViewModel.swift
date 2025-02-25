//
//  DashboardViewModel.swift
//  Compound
//
//  Created by Vikranth Kumar on 2/24/25.
//

import Foundation

@Observable class DashboardViewModel {
    
    private var model = DashboardModel()
    var sortOption: DashboardModel.SortOption = .name
    var didFail = false
    
    init() { }
    
    var advisors: Advisors? {
        model.advisors
    }
    
    @MainActor
    func getAdvisors() async throws {
        do {
            didFail = false
            let advisors = try await NetworkRepository.getAdvisors()
            model.saveAdvisors(with: advisors)
        } catch {
            didFail = true
        }
    }
    
    @MainActor
    func sortAdvisors() {
        model.sortAdvisors(by: sortOption)
    }
    
}

