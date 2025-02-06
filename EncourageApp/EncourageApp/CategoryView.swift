//
//  CategoryView.swift
//  EncourageApp
//
//  Created by Giannfranco Crovetto on 12/18/24.
//

import SwiftUI

struct CategoryView: View {
    var categoryName: String // Pass the category name

    var body: some View {
        VStack(spacing: 20) {
            // Dynamic Category Title
            Text("Category: \(categoryName)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
//            // Placeholder Message
//            Text("Congrats! You made it to this file!")
//                .font(.title2)
//                .multilineTextAlignment(.center)
//                .padding()

            // Generate Button
            Button(action: {
                // Add logic to generate a message
                print("Generate button tapped!")
            }) {
                Text("Generate")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 150, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            Spacer() // Push content to the top
        }
        .padding()
        .navigationTitle("Category View") // Navigation bar title
    }
}

#Preview {
    CategoryView(categoryName: "Motivation") // Example category
}
