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
    @State private var rating: String? = nil // Track rating ("up", "down", or nil)
    @State private var timeRemaining: String = "24:00" // Time until reset
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
                .frame(width: 300, height: 190)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 3)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 4) {
                Text("Rate?")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()

                // Rating Buttons (Thumbs Up & Thumbs Down)
                HStack(spacing: 30) { // Controls spacing between buttons
                    Button(action: { rating = "up" }) {
                        Image(systemName: "hand.thumbsup.fill")
                            .foregroundColor(rating == "up" ? .green : .gray)
                            .font(.largeTitle)
                    }
                    //.padding()

                    Button(action: { rating = "down" }) {
                        Image(systemName: "hand.thumbsdown.fill")
                            .foregroundColor(rating == "down" ? .red : .gray)
                            .font(.largeTitle)
                    }
                    //.padding()
                }
            }
            
            // Display countdown timer
            Text("Next reset in: \(timeRemaining)")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.top, 10)
        }
        .padding()
        .onAppear(perform: updateCountdown)
    }
    
    // Function to generate a message that hasn't been used in the last 24 hours
    func generateMessage() {
        var usedMessages = getStoredMessages()
        let currentTime = Date().timeIntervalSince1970
        let expirationTime = 86400.0 // 24 hours in seconds

        // Remove expired messages
        usedMessages = usedMessages.filter { currentTime - $0.value < expirationTime }

        // Get available messages
        let availableMessages = MessageArrays.messages[categoryName]?.filter { !usedMessages.keys.contains($0) } ?? []

        if let newMessage = availableMessages.randomElement() {
            generatedMessage = newMessage
            usedMessages[newMessage] = currentTime
            saveStoredMessages(usedMessages)
            updateCountdown()
        } else {
            generatedMessage = "No new messages available. Try again later!"
        }

        rating = nil // Reset rating when a new message is generated
    }

    // Retrieve stored messages from UserDefaults
    func getStoredMessages() -> [String: TimeInterval] {
        if let savedData = UserDefaults.standard.dictionary(forKey: categoryName) as? [String: TimeInterval] {
            return savedData
        }
        return [:]
    }

    // Save messages to UserDefaults
    func saveStoredMessages(_ messages: [String: TimeInterval]) {
        UserDefaults.standard.set(messages, forKey: categoryName)
    }

    // Updates the countdown to new message generation
    func updateCountdown() {
        let storedMessages = getStoredMessages()
        let currentTime = Date().timeIntervalSince1970
        let expirationTime = 86400.0 // 24 hours in seconds

        // Find the earliest expiration time of any stored message
        if let nextReset = storedMessages.values.map({ $0 + expirationTime }).min() {
            let remainingTime = max(nextReset - currentTime, 0) // Ensure non-negative time

            let hours = Int(remainingTime) / 3600
            let minutes = (Int(remainingTime) % 3600) / 60

            timeRemaining = String(format: "%02d:%02d", hours, minutes)

            // Refresh every minute
            DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
                updateCountdown()
            }
        } else {
            timeRemaining = "24:00"
        }
    }
}

#Preview {
    CategoryView(categoryName: "Motivation")
}
