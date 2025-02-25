//
//  AccountDetailsView.swift
//  Compound
//
//  Created by Vikranth Kumar on 2/24/25.
//

import SwiftUI

struct AccountDetailsView: View {
    @Bindable var viewModel: AccountDetailsViewModel
    
    init(account: Account) {
        viewModel = .init(account: account)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: .spacing2) {
                summaryView
                
                ContentLoadingView(
                    isLoading: viewModel.holdings == nil,
                    isEmpty: viewModel.holdings?.isEmpty == true,
                    hasError: viewModel.didFail,
                    content: { holdingsContent },
                    emptyContent: { emptyDataView },
                    loadingContent: { loaderView },
                    loadAction: { try await viewModel.getHoldings() }
                )
            }
        }
        .scrollIndicators(.hidden)
        .navigationTitle(viewModel.account.name + String.sHoldings)
        .refreshable {
            try? await viewModel.getHoldings()
        }
    }
    
    private var summaryView: some View {
        CompoundCard {
            VStack(alignment: .leading, spacing: .spacing2) {
                Text(String.accountInformation)
                    .font(.headline1)
                    .foregroundColor(.text)
                
                InfoRow(label: String.accountNumber, value: viewModel.account.number)
                
                Divider()
                
                InfoRow(label: String.custodian, value: viewModel.account.custodian)
                
                Divider()
                
                InfoRow(label: String.repId, value: viewModel.account.repId)
                
                Divider()
                
                InfoRow(
                    label: String.totalValue,
                    value: viewModel.account.totalValue.formattedCurrency,
                    isHighlighted: true
                )
            }
        }
        .padding(.horizontal, .padding3)
        .padding(.top, .padding2)
        .slideInOnAppear(from: .top)
    }
    
    private var holdingsContent: some View {
        VStack(spacing: .spacing2) {
            SectionHeader(
                title: String.holdings,
                count: viewModel.holdings?.count
            )
            
            LazyVStack(spacing: .spacing2) {
                if let holdings = viewModel.holdings, !holdings.isEmpty {
                    ForEach(Array(zip(holdings.indices, holdings)), id: \.1.id) { index, holding in
                        HoldingRow(holding: holding)
                            .padding(.horizontal, .padding3)
                            .slideInOnAppear(delay: Double(index) * 0.05)
                    }
                }
            }
            .padding(.bottom, .padding2)
        }
    }
    
    private var emptyDataView: some View {
        EmptyDataView(type: .holdings) {
            try await viewModel.getHoldings()
        }
        .fadeInOnAppear()
    }
    
    private var loaderView: some View {
        LoaderView(didFail: $viewModel.didFail) {
            try await viewModel.getHoldings()
        }
        .fadeInOnAppear()
    }
}
