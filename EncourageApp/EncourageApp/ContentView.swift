//
//  ContentView.swift
//  EncourageApp
//
//  Created by Giannfranco Crovetto on 11/14/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager // Access the authManager
    
    let categories = ["Motivation", "Mindfulness", "Anxiety", "Depression", "Overthinking", "Wellness", "Inspiration"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Title
                Text("Welcome to Encourage!")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .fontWeight(.bold)
                    .padding(.top)
                Text("Categories:")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // Scrollable body
                ScrollView(.vertical) {
                    VStack(spacing: 14) {
                        ForEach(categories, id: \.self) { category in
                            CategoryCard(categoryName: category)
                        }
                        
                        Spacer()
                    }
                    .padding(.bottom, 40)
                }
            }
            .padding()
        }
    }
}

// Reusable Category Card Component
struct CategoryCard: View {
    let categoryName: String
    
    var body: some View {
        let style = CategoryStyle.getStyle(for: categoryName)
        
        NavigationLink(destination: CategoryView(categoryName: categoryName)) {
            HStack(spacing: 15) {
                // Icon with background circle
                ZStack {
                    Circle()
                        .fill(style.color.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: style.icon)
                        .font(.system(size: 28))
                        .foregroundColor(style.color)
                }
                
                // Category name
                Text(categoryName)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                // Chevron arrow
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
            }
            .padding()
            .frame(width: 350, height: 90)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemGray6))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
            )
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthManager()) // Pass an instance of AuthManager for preview
}
