//
//  DashboardView.swift
//  Compound
//
//  Created by Vikranth Kumar on 2/24/25.
//

import SwiftUI

struct DashboardView: View {
    @Bindable var viewModel: DashboardViewModel
    @State private var showSortOptions = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                
                ContentLoadingView(
                    isLoading: viewModel.advisors == nil,
                    isEmpty: viewModel.advisors?.isEmpty == true,
                    hasError: viewModel.didFail,
                    content: { advisorsContent },
                    emptyContent: { emptyDataView },
                    loadingContent: { loaderView },
                    loadAction: { try await viewModel.getAdvisors() }
                )
            }
            .navigationTitle(String.advisors)
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: Advisor.self) { advisor in
                AdvisorDetailsView(advisor: advisor)
            }
            .refreshable {
                try? await viewModel.getAdvisors()
            }
        }
    }
    
    private var advisorsContent: some View {
        VStack(spacing: 0) {
            SortOptionsView(
                selectedOption: $viewModel.sortOption,
                showOptions: $showSortOptions,
                onSelect: { _ in viewModel.sortAdvisors() }
            )
            
            ScrollView {
                LazyVStack(spacing: .spacing2) {
                    if let advisors = viewModel.advisors, !advisors.isEmpty {
                        ForEach(Array(zip(advisors.indices, advisors)), id: \.1.id) { index, advisor in
                            NavigationLink(value: advisor) {
                                AdvisorRow(advisor: advisor)
                                    .slideInOnAppear(delay: Double(index) * 0.05)
                            }
                            .plainButton()
                            .padding(.horizontal, .padding3)
                        }
                    }
                }
                .padding(.vertical, .padding2)
            }
            .scrollIndicators(.hidden)
        }
    }
    
    private var emptyDataView: some View {
        EmptyDataView(type: .advisors) {
            try await viewModel.getAdvisors()
        }
        .fadeInOnAppear()
    }
    
    private var loaderView: some View {
        LoaderView(didFail: $viewModel.didFail) {
            try await viewModel.getAdvisors()
        }
        .fadeInOnAppear()
    }
}
