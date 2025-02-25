//
//  View++.swift
//  Compound
//
//  Created by Vikranth Kumar on 2/24/25.
//

import SwiftUI

extension View {
    func fullFrame() -> some View {
        frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func plainButton() -> some View {
        buttonStyle(PlainButtonStyle())
    }
    
    func plainList() -> some View {
        listStyle(.plain)
    }
    
    func setCompactButton() -> some View {
        font(.title3)
            .padding(.padding2)
            .padding(.horizontal)
            .background(Color.theme)
            .cornerRadius(.cornerRadius1)
    }
    
    func cardStyle() -> some View {
        background(
            RoundedRectangle(cornerRadius: .cornerRadius3)
                .fill(Color.backgroundSecondary)
                .overlay(
                    RoundedRectangle(cornerRadius: .cornerRadius3)
                        .stroke(Color.border, lineWidth: 1)
                )
                .shadow(color: Color.primary.opacity(0.05), radius: 2, x: 0, y: 2)
        )
    }
    
    func chipStyle() -> some View {
        font(.caption1)
            .foregroundColor(.theme)
            .padding(.horizontal, .padding1)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: .cornerRadius1)
                    .fill(Color.primaryLight)
                    .overlay(
                        RoundedRectangle(cornerRadius: .cornerRadius1)
                            .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                    )
            )
    }
    
    func pressEffect() -> some View {
        modifier(PressEffectViewModifier())
    }
    
    func fadeInOnAppear() -> some View {
        modifier(FadeInViewModifier())
    }
    
    func slideInOnAppear(from edge: Edge = .bottom, delay: Double = 0) -> some View {
        modifier(SlideInViewModifier(edge: edge, delay: delay))
    }
}

