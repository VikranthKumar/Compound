//
//  CompoundApp.swift
//  Compound
//
//  Created by Vikranth Kumar on 2/23/25.
//

import SwiftUI

@main
struct CompoundApp: App {
    
    @State var dashboardViewModel = DashboardViewModel()
    
    var body: some Scene {
        WindowGroup {
            DashboardView(viewModel: dashboardViewModel)
        }
    }
}
