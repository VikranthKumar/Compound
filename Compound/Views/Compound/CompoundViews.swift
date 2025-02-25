//
//  CompoundViews.swift
//  Compound
//
//  Created by Vikranth Kumar on 2/25/25.
//

import SwiftUI

struct CompoundButton<Label>: View where Label: View {
    
    let showState: Bool
    let action: () async throws -> Void
    let label: () -> Label
    
    @State private var state: Status = .idle
    
    init(showState: Bool = true, action: @escaping () async throws -> Void, @ViewBuilder label: @escaping () -> Label) {
        self.action = action
        self.label = label
        self.showState = showState
    }
    
    var body: some View {
        Button(action: {
            Task {
                await performTask()
            }
        }) {
            label()
                .plainButton()
                .overlay(trailingOverlay, alignment: .trailing)
                .animation(.easeInOut(duration: 0.3), value: state)
        }
        .disabled(state == .active)
        .opacity(state == .active ? 0.8 : 1)
        .animation(.easeInOut(duration: 0.3), value: state)
    }
    
    private var trailingOverlay: some View {
        Group {
            if showState {
                if state == .active {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.trailing)
                } else if state == .error {
                    Image(systemName: .errorImage)
                        .foregroundColor(.yellow)
                        .padding(.trailing)
                }
            }
        }
        .transition(.opacity)
    }
    
    private func performTask() async {
        updateState(to: .active)
        handleStateChange()
        do {
            try await action()
            updateState(to: .success)
            
        } catch {
            updateState(to: .error)
        }
    }
    
    private func updateState(to newState: Status) {
        withAnimation {
            state = newState
            handleStateChange()
        }
    }
    
    private func handleStateChange() {
        switch state {
            case .idle:
                FeedbackGenerator.shared.prepare(.light)
            case .paused:
                FeedbackGenerator.shared.generate(.warning)
            case .active:
                FeedbackGenerator.shared.generate(.selection)
            case .canceled:
                FeedbackGenerator.shared.generate(.rigid)
            case .success:
                FeedbackGenerator.shared.generate(.success)
            case .error:
                FeedbackGenerator.shared.generate(.error)
        }
    }
    
    enum Status {
        case idle, paused, active, canceled, success, error
    }
}

struct LoaderView: View {
    let backgroundColor: Color
    let loaderColor: Color
    let didFail: Binding<Bool>
    let action: () async throws -> Void
    
    init(backgroundColor: Color = .clear, loaderColor: Color = .theme, didFail: Binding<Bool>, action: @escaping () async throws -> Void) {
        self.backgroundColor = backgroundColor
        self.loaderColor = loaderColor
        self.didFail = didFail
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: .spacing3) {
            Spacer()
            if didFail.wrappedValue {
                failureView
                    .transition(.opacity.combined(with: .scale))
                    .fadeInOnAppear()
            } else {
                loadingView
                    .transition(.opacity.combined(with: .scale))
                    .fadeInOnAppear()
            }
            Spacer()
        }
        .fullFrame()
    }
    
    private var failureView: some View {
        VStack(spacing: .spacing3) {
            Image(systemName: .errorImage)
                .resizable()
                .scaledToFit()
                .foregroundColor(.error)
                .frame(maxWidth: 233, maxHeight: 130)
                .symbolEffect(.pulse, options: .repeating)
            
            Text(verbatim: .defaultError)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, .padding3)
            
            retryButton
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: .spacing3) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: loaderColor))
                .scaleEffect(2)
                .padding()
            
            Text(verbatim: .loading)
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
    
    private var retryButton: some View {
        CompoundButton {
            Task {
                try await action()
            }
        } label: {
            Text(verbatim: .retry)
                .multilineTextAlignment(.center)
                .foregroundColor(.buttonText)
                .setCompactButton()
        }
    }
}

struct EmptyDataView: View {
    let type: ViewType
    let action: (() async throws -> Void)?
    
    init(type: ViewType, action: (() async throws -> Void)? = nil) {
        self.type = type
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: .spacing3) {
            Spacer()
            
            Image(systemName: type.icon)
                .font(.largeTitle1)
                .foregroundColor(.secondary)
                .symbolEffect(.pulse)
                .frame(width: 80, height: 80)
                .padding(.bottom, .spacing1)
            
            Text(type.title)
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.horizontal, .padding3)
                .fixedSize(horizontal: false, vertical: true)
            
            if let actionUnwrapped = action {
                Spacer()
                    .frame(height: .spacing2)
                
                CompoundButton {
                    Task {
                        try await actionUnwrapped()
                    }
                } label: {
                    Text(String.retry)
                        .foregroundColor(.buttonText)
                        .multilineTextAlignment(.center)
                        .setCompactButton()
                }
                .shadow(color: Color.primary.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            
            Spacer()
        }
        .foregroundColor(.text)
        .fullFrame()
        .background {
            Color.background.opacity(0.75)
        }
        .slideInOnAppear(from: .bottom)
    }
    
    enum ViewType {
        case advisors
        case accounts
        case holdings
        
        var icon: String {
            switch self {
                case .advisors: return .personImage
                case .accounts: return .folderImage
                case .holdings: return .folderImage
            }
        }
        
        var title: String {
            switch self {
                case .advisors: return .noAdvisors
                case .accounts: return .noAccounts
                case .holdings: return .noHoldings
            }
        }
    }
}


struct CircleInitialsView: View {
    let name: String
    
    private var initials: String {
        name.components(separatedBy: String.space)
            .prefix(2)
            .compactMap { $0.first }
            .map(String.init)
            .joined()
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.primaryLight, Color.primary.opacity(0.4)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    Circle()
                        .stroke(Color.primary.opacity(0.15), lineWidth: 1)
                )
            Text(initials)
                .font(.headline1)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
    }
}

struct CompoundCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(.padding3)
            .cardStyle()
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    let isHighlighted: Bool
    
    init(label: String, value: String, isHighlighted: Bool = false) {
        self.label = label
        self.value = value
        self.isHighlighted = isHighlighted
    }
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .font(.subheadline1)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(isHighlighted ? .title3 : .subheadline1)
                .fontWeight(isHighlighted ? .bold : .regular)
                .foregroundColor(isHighlighted ? .primary : .text)
                .multilineTextAlignment(.trailing)
        }
    }
}

struct StatItem: View {
    let title: String
    let value: String
    let alignment: HorizontalAlignment
    
    init(title: String, value: String, alignment: HorizontalAlignment = .leading) {
        self.title = title
        self.value = value
        self.alignment = alignment
    }
    
    var body: some View {
        VStack(alignment: alignment, spacing: .spacing1) {
            Text(title)
                .font(.subheadline1)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title2)
                .bold()
                .foregroundColor(.primary)
        }
    }
}

struct AvatarView: View {
    let name: String
    let size: CGFloat
    
    init(name: String, size: CGFloat = 40) {
        self.name = name
        self.size = size
    }
    
    private var initials: String {
        name.components(separatedBy: String.space)
            .prefix(2)
            .compactMap { $0.first }
            .map(String.init)
            .joined()
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.primaryLight, Color.primary.opacity(0.4)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay {
                    Circle()
                        .stroke(Color.primary.opacity(0.15), lineWidth: 1)
                }
            
            Text(initials)
                .font(.headline1)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
        .frame(width: size, height: size)
        .shadow(color: Color.primary.opacity(0.1), radius: 3, x: 0, y: 2)
    }
}

struct SectionHeader: View {
    let title: String
    let count: Int?
    let countSuffix: String?
    
    init(title: String, count: Int? = nil, countSuffix: String? = nil) {
        self.title = title
        self.count = count
        self.countSuffix = countSuffix
    }
    
    var body: some View {
        HStack {
            if let count = count {
                Text("\(count.toString) \(countSuffix ?? title)")
                    .font(.headline1)
                    .foregroundColor(.text)
            } else {
                Text(title)
                    .font(.headline1)
                    .foregroundColor(.text)
            }
            Spacer()
        }
        .padding(.horizontal, .padding3)
    }
}

struct PriceChangeIndicator: View {
    let price: Double
    
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: price > 0 ? String.arrowUpRightImage : String.arrowDownRightImage)
            Text("\(abs(price).percentage)")
                .font(.caption1)
        }
        .foregroundColor(price >= 0 ? .success : .error)
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background {
            RoundedRectangle(cornerRadius: .cornerRadius1)
                .fill(price >= 0 ? Color.success.opacity(0.15) : Color.error.opacity(0.15))
        }
    }
}

struct AdvisorRow: View {
    let advisor: Advisor
    
    var body: some View {
        HStack(alignment: .top, spacing: .spacing2) {
            AvatarView(name: advisor.name, size: 50)
            
            VStack(alignment: .leading, spacing: .spacing1) {
                Text(advisor.name)
                    .font(.headline1)
                    .foregroundColor(.text)
                
                HStack(spacing: .spacing1) {
                    Image(systemName: String.chartImage)
                        .foregroundColor(.theme)
                        .font(.caption1)
                    
                    Text(advisor.totalAssets.formattedCurrency)
                        .font(.subheadline1)
                        .bold()
                        .foregroundColor(.primary)
                        .lineLimit(1)
                }
                .padding(.top, 2)
                
                HStack(spacing: .spacing1) {
                    Image(systemName: String.buildingImage)
                        .foregroundColor(.secondary)
                        .font(.caption1)
                    
                    Text(advisor.custodians.map { $0.name }.joined(separator: ", "))
                        .font(.caption1)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            Image(systemName: String.chevronRightImage)
                .foregroundColor(.secondary)
                .font(.caption1)
                .padding(.top, .padding1)
        }
        .padding(.padding3)
        .cardStyle()
    }
}

struct AccountRow: View {
    let account: Account
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: .spacing1) {
                Text(account.name)
                    .font(.headline1)
                    .foregroundColor(.text)
                
                Text(account.number)
                    .font(.caption1)
                    .foregroundColor(.secondary)
                
                HStack {
                    Image(systemName: String.buildingImage)
                        .foregroundColor(.secondary)
                        .font(.caption1)
                    
                    Text(account.custodian)
                        .font(.caption1)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: .spacing1) {
                Text(account.totalValue.formattedCurrency)
                    .font(.subheadline1)
                    .bold()
                    .foregroundColor(.primary)
                
                Text(account.holdingsCount.toString + String.holding + account.holdingsCount.countSuffix)
                    .font(.caption1)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Image(systemName: String.chevronRightImage)
                    .foregroundColor(.secondary)
                    .font(.caption1)
            }
        }
        .padding(.padding3)
        .cardStyle()
    }
}

struct HoldingRow: View {
    let holding: Holding
    
    var body: some View {
        VStack(alignment: .leading, spacing: .spacing1) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(holding.ticker)
                        .font(.headline1)
                        .foregroundColor(.text)
                    
                    Text(holding.name)
                        .font(.caption1)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Text((Double(holding.units) * holding.unitPrice).formattedCurrency)
                    .font(.subheadline1)
                    .bold()
                    .foregroundColor(.primary)
            }
            
            HStack(spacing: 4) {
                Text(holding.units.toString + String.unit + holding.units.countSuffix)
                    .font(.caption1)
                
                Text(String.x)
                    .font(.caption1)
                    .foregroundColor(.secondary)
                
                Text(holding.unitPrice.formattedCurrency)
                    .font(.caption1)
                
                Spacer()
                
                PriceChangeIndicator(price: holding.unitPrice)
            }
            .foregroundColor(.secondary)
        }
        .padding(.padding3)
        .cardStyle()
    }
}

struct SortOptionsView<Option: Identifiable & CaseIterable & RawRepresentable & Hashable>: View where Option.RawValue == String, Option.AllCases: RandomAccessCollection {
    @Binding var selectedOption: Option
    @Binding var showOptions: Bool
    let onSelect: (Option) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: String.sortImage)
                    .foregroundColor(.theme)
                    .font(.title3)
                
                Text(String.sortBy)
                    .font(.headline1)
                    .foregroundColor(.text)
                
                Spacer()
                
                CompoundButton {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showOptions.toggle()
                    }
                } label: {
                    Image(systemName: showOptions ? String.chevronUpImage : String.chevronDownImage)
                        .foregroundColor(.secondary)
                        .font(.subheadline1)
                }
            }
            .padding(.horizontal, .padding3)
            .padding(.vertical, .padding2)
            
            if showOptions {
                VStack(spacing: .spacing2) {
                    ForEach(Array(Option.allCases), id: \.self) { option in
                        sortOptionRow(option)
                    }
                }
                .padding(.horizontal, .padding3)
                .padding(.bottom, .padding2)
                .transition(.asymmetric(insertion: .move(edge: .top).combined(with: .opacity),
                                        removal: .opacity))
            }
        }
        .background {
            RoundedRectangle(cornerRadius: .cornerRadius3)
                .fill(Color.backgroundSecondary)
                .shadow(color: Color.primary.opacity(0.08), radius: 8, x: 0, y: 4)
        }
        .padding([.horizontal, .bottom], .padding3)
    }
    
    private func sortOptionRow(_ option: Option) -> some View {
        CompoundButton {
            withAnimation {
                selectedOption = option
                onSelect(option)
            }
        } label: {
            HStack {
                Text(option.rawValue)
                    .font(.subheadline1)
                    .foregroundColor(selectedOption == option ? .primary : .text)
                
                Spacer()
                
                if selectedOption == option {
                    Image(systemName: String.checkmarkImage)
                        .foregroundColor(.theme)
                        .font(.subheadline1)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.vertical, .padding1)
            .padding(.horizontal, .padding2)
            .background {
                RoundedRectangle(cornerRadius: .cornerRadius1)
                    .fill(selectedOption == option ? Color.primaryLight : Color.background)
            }
            .overlay {
                RoundedRectangle(cornerRadius: .cornerRadius1)
                    .stroke(selectedOption == option ? Color.primary.opacity(0.3) : Color.separator, lineWidth: 1)
            }
        }
        .plainButton()
    }
}

protocol LoadableView: View {
    associatedtype LoadingState
    var isLoading: Bool { get }
    var isEmpty: Bool { get }
    var hasError: Bool { get }
    func loadData() async throws
}

struct ContentLoadingView<Content: View, EmptyContent: View, LoadingContent: View>: View {
    let isLoading: Bool
    let isEmpty: Bool
    let hasError: Bool
    let content: () -> Content
    let emptyContent: () -> EmptyContent
    let loadingContent: () -> LoadingContent
    let loadAction: () async throws -> Void
    
    var body: some View {
        Group {
            if isLoading {
                loadingContent()
            } else if isEmpty {
                emptyContent()
            } else {
                content()
            }
        }
        .task {
            try? await loadAction()
        }
    }
}

struct PressEffectViewModifier: ViewModifier {
    @State private var isPressed = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .opacity(isPressed ? 0.9 : 1.0)
            .contentShape(Rectangle())
            .onTapGesture {
                Task {
                    withAnimation(.spring(response: 0.2)) {
                        isPressed = true
                    }
                    
                    try? await Task.sleep(for: .milliseconds(200))
                    
                    withAnimation(.spring(response: 0.2)) {
                        isPressed = false
                    }
                }
            }
    }
}

struct FadeInViewModifier: ViewModifier {
    @State private var opacity: Double = 0
    
    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: 0.3)) {
                    opacity = 1
                }
            }
    }
}

struct SlideInViewModifier: ViewModifier {
    let edge: Edge
    let delay: Double
    @State private var offset: CGFloat = 50
    @State private var opacity: Double = 0
    
    func body(content: Content) -> some View {
        content
            .offset(
                x: edge == .leading ? -offset : (edge == .trailing ? offset : 0),
                y: edge == .top ? -offset : (edge == .bottom ? offset : 0)
            )
            .opacity(opacity)
            .onAppear {
                Task {
                    if delay > 0 {
                        try? await Task.sleep(for: .seconds(delay))
                    }
                    
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        offset = 0
                        opacity = 1
                    }
                }
            }
    }
}
