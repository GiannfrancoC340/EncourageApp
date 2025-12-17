//
//  CategoryStyle.swift
//  EncourageApp
//
//  Created by Giannfranco Crovetto on 12/17/25.
//

import SwiftUI

struct CategoryStyle {
    let icon: String
    let color: Color
    
    static let styles: [String: CategoryStyle] = [
        "Motivation": CategoryStyle(
            icon: "flame.fill",
            color: Color.orange
        ),
        "Mindfulness": CategoryStyle(
            icon: "leaf.fill",
            color: Color.green
        ),
        "Anxiety": CategoryStyle(
            icon: "heart.fill",
            color: Color.blue
        ),
        "Depression": CategoryStyle(
            icon: "sun.max.fill",
            color: Color.yellow
        ),
        "Overthinking": CategoryStyle(
            icon: "brain.head.profile",
            color: Color.purple
        ),
        "Wellness": CategoryStyle(
            icon: "figure.walk",
            color: Color.mint
        ),
        "Inspiration": CategoryStyle(
            icon: "sparkles",
            color: Color.pink
        )
    ]
    
    static func getStyle(for category: String) -> CategoryStyle {
        return styles[category] ?? CategoryStyle(icon: "star.fill", color: .gray)
    }
}
