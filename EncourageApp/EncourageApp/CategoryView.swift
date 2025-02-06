//
//  CategoryView.swift
//  EncourageApp
//
//  Created by Giannfranco Crovetto on 12/18/24.
//

import SwiftUI

struct CategoryView: View {
    var categoryName: String // Pass the category name
    @State private var generatedMessage: String = "Tap 'Generate' to get a message!"

    // Sample messages for different categories
    let messages: [String: [String]] = [
        "Motivation": [
            "Believe in yourself!",
            "Keep pushing forward!",
            "Success is just around the corner!",
            "Never give up!",
            "Hard work pays off!"
        ],
        "Wellness": [
            "Take care of your mind and body.",
            "Rest and self-care are so important.",
            "A healthy mind brings a healthy life.",
            "Breathe deeply and embrace the moment.",
            "You deserve time for yourself."
        ],
        "Inspiration": [
            "Dream big and dare to fail.",
            "The best time for new beginnings is now.",
            "Your potential is limitless.",
            "Every day is a second chance.",
            "Inspiration exists, but it has to find you working."
        ],
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Category: \(categoryName)")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            // Generate Button
            Button(action: generateMessage) {
                Text("Generate")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()
                    .frame(width: 200)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            // Message Display Box
            Text(generatedMessage)
                .frame(width: 300, height: 100)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 3)
                .multilineTextAlignment(.center)
        }
        .padding()
        .navigationTitle("Category View")
    }
    
    // Function to generate a random message
    func generateMessage() {
        if let categoryMessages = messages[categoryName] {
            generatedMessage = categoryMessages.randomElement() ?? "No messages available."
        } else {
            generatedMessage = "No messages found for this category."
        }
    }
}

#Preview {
    CategoryView(categoryName: "Motivation") // Example category
}
