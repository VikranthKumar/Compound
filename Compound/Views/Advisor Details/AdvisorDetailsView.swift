//
//  AdvisorDetailsView.swift
//  Compound
//
//  Created by Vikranth Kumar on 2/24/25.
//

import SwiftUI

struct AdvisorDetailsView: View {
    @Bindable var viewModel: AdvisorDetailsViewModel
    
    init(advisor: Advisor) {
        viewModel = .init(advisor: advisor)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: .spacing2) {
                summaryView
                
                ContentLoadingView(
                    isLoading: viewModel.accounts == nil,
                    isEmpty: viewModel.accounts?.isEmpty == true,
                    hasError: viewModel.didFail,
                    content: { accountsContent },
                    emptyContent: { emptyDataView },
                    loadingContent: { loaderView },
                    loadAction: { try await viewModel.getAccounts() }
                )
            }
        }
        .scrollIndicators(.hidden)
        .navigationTitle(viewModel.advisor.name.firstName + String.sAccounts)
        .navigationDestination(for: Account.self) { account in
            AccountDetailsView(account: account)
        }
        .refreshable {
            try? await viewModel.getAccounts()
        }
    }
    
    private var summaryView: some View {
        CompoundCard {
            VStack(alignment: .leading, spacing: .spacing1) {
                HStack {
                    AvatarView(name: viewModel.advisor.name)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(String.summary)
                            .font(.headline1)
                            .foregroundColor(.text)
                        
                        Text(viewModel.advisor.name)
                            .font(.subheadline1)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                .padding(.bottom, .spacing1)
                
                Divider()
                
                HStack(spacing: .spacing3) {
                    StatItem(
                        title: String.totalAssets,
                        value: viewModel.advisor.totalAssets.formattedCurrency
                    )
                    
                    Spacer()
                    
                    StatItem(
                        title: String.custodians,
                        value: viewModel.advisor.custodians.count.toString,
                        alignment: .trailing
                    )
                }
                .padding(.vertical, .spacing1)
                
                if !viewModel.advisor.custodians.isEmpty {
                    Divider()
                    
                    VStack(alignment: .leading, spacing: .spacing1) {
                        Text(String.custodians)
                            .font(.subheadline1)
                            .foregroundColor(.secondary)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: .spacing1) {
                                ForEach(viewModel.advisor.custodians) { custodian in
                                    Text(custodian.name)
                                        .chipStyle()
                                }
                            }
                        }
                    }
                    .padding(.top, .spacing1)
                }
            }
        }
        .padding(.horizontal, .padding3)
        .padding(.top, .padding2)
        .slideInOnAppear(from: .top)
    }
    
    private var accountsContent: some View {
        VStack(spacing: .spacing2) {
            SectionHeader(
                title: String.accountsLabel,
                count: viewModel.accounts?.count
            )
            
            LazyVStack(spacing: .spacing2) {
                if let accounts = viewModel.accounts, !accounts.isEmpty {
                    ForEach(Array(zip(accounts.indices, accounts)), id: \.1.id) { index, account in
                        NavigationLink(value: account) {
                            AccountRow(account: account)
                                .slideInOnAppear(delay: Double(index) * 0.05)
                        }
                        .plainButton()
                        .padding(.horizontal, .padding3)
                    }
                }
            }
            .padding(.bottom, .padding2)
        }
    }
    
    private var emptyDataView: some View {
        EmptyDataView(type: .accounts) {
            try await viewModel.getAccounts()
        }
        .fadeInOnAppear()
    }
    
    private var loaderView: some View {
        LoaderView(didFail: $viewModel.didFail) {
            try await viewModel.getAccounts()
        }
        .fadeInOnAppear()
    }
}
