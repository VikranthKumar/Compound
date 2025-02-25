//
//  DashboardModel.swift
//  Compound
//
//  Created by Vikranth Kumar on 2/24/25.
//

import SwiftUI

struct DashboardModel {
    
    private(set) var advisors: Advisors?
    
    init() { }
    
    @MainActor
    mutating func saveAdvisors(with newAdvisors: Advisors) {
        advisors = newAdvisors
        sortAdvisors()
    }
    
    @MainActor
    mutating func sortAdvisors(by sortOption: SortOption = .name) {
        switch sortOption {
            case .name:
                advisors?.sort { $0.name < $1.name }
            case .totalAssets:
                advisors?.sort { $0.totalAssets > $1.totalAssets }
        }
    }
    
    enum SortOption: String, CaseIterable, Identifiable {
        case name = "Name"
        case totalAssets = "Total Assets"
        
        var id: String { rawValue }
    }
}
