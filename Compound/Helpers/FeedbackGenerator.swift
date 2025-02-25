//
//  FeedbackGenerator.swift
//  Compound
//
//  Created by Vikranth Kumar on 2/24/25.
//

import SwiftUI
import UIKit

final class FeedbackGenerator {
    static let shared = FeedbackGenerator()
    
    enum ImpactFeedbackStyle: Hashable {
        case light
        case medium
        case heavy
        case soft
        case rigid
    }
    
    enum NotificationFeedbackStyle: Hashable {
        case success
        case warning
        case error
    }
    
    enum FeedbackStyle: Hashable {
        case impact(ImpactFeedbackStyle)
        case notification(NotificationFeedbackStyle)
        case selection
        
        static let light = Self.impact(.light)
        static let medium = Self.impact(.medium)
        static let heavy = Self.impact(.heavy)
        static let soft = Self.impact(.soft)
        static let rigid = Self.impact(.rigid)
        static let success = Self.notification(.success)
        static let warning = Self.notification(.warning)
        static let error = Self.notification(.error)
    }
    
    private init() { }
    
    private var impactFeedbackGenerators: [UIImpactFeedbackGenerator.FeedbackStyle: UIImpactFeedbackGenerator] = [:]
    private lazy var selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    private lazy var notificationFeedbackGenerator = UINotificationFeedbackGenerator()
    
    private func impactFeedbackGenerator(for style: UIImpactFeedbackGenerator.FeedbackStyle) -> UIImpactFeedbackGenerator {
        if let generator = impactFeedbackGenerators[style] {
            return generator
        } else {
            let generator = UIImpactFeedbackGenerator(style: style)
            impactFeedbackGenerators[style] = generator
            return generator
        }
    }
    
    func prepare(_ feedback: FeedbackStyle) {
        //        if AppData.shared.isHapticsEnabled.unWrapped {
        switch feedback  {
            case .impact(let style):
                impactFeedbackGenerator(for: .init(style)).prepare()
            case .selection:
                selectionFeedbackGenerator.prepare()
            case .notification:
                notificationFeedbackGenerator.prepare()
        }
        //        }
    }
    
    func generate(_ feedback: FeedbackStyle) {
        //        if AppData.shared.isHapticsEnabled.unWrapped {
        switch feedback  {
            case let .impact(style):
                impactFeedbackGenerator(for: .init(style)).impactOccurred()
            case .selection:
                selectionFeedbackGenerator.selectionChanged()
            case let .notification(type):
                notificationFeedbackGenerator.notificationOccurred(.init(type))
        }
        //        }
    }
}

extension UIImpactFeedbackGenerator.FeedbackStyle {
    init(_ style: FeedbackGenerator.ImpactFeedbackStyle) {
        switch style {
            case .light:
                self = .light
            case .medium:
                self = .medium
            case .heavy:
                self = .heavy
            case .soft:
                self = .soft
            case .rigid:
                self = .rigid
        }
    }
}

extension UINotificationFeedbackGenerator.FeedbackType {
    init(_ style: FeedbackGenerator.NotificationFeedbackStyle) {
        switch style {
            case .success:
                self = .success
            case .warning:
                self = .warning
            case .error:
                self = .error
        }
    }
}

struct FeedbackGeneratorEnvironmentKey: EnvironmentKey {
    static let defaultValue = FeedbackGenerator.shared
}

extension EnvironmentValues {
    var feedbackGenerator: FeedbackGenerator {
        get {
            self[FeedbackGeneratorEnvironmentKey.self]
        } set {
            self[FeedbackGeneratorEnvironmentKey.self] = newValue
        }
    }
}
