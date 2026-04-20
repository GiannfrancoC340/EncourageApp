//
//  CategoryView.swift
//  EncourageApp
//
//  Created by Giannfranco Crovetto on 12/18/24.
//

import SwiftUI
import FirebaseFirestore

struct CategoryView: View {
    @EnvironmentObject var authManager: AuthManager // Access user email
    var categoryName: String // Pass the category name
    @State private var generatedMessage: String = "Tap 'Generate' to get a message!"
    @State private var rating: String? = nil // Track rating ("up", "down", or nil)
    @State private var timeRemaining: String = "24:00" // Time until reset
    @State private var isFavorited: Bool = false // Track if current message is favorited
    
    let db = Firestore.firestore() // Firestore instance
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Category: \(categoryName)")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 2)
            
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
                HStack(spacing: 30) {
                    Button(action: {
                        rating = "up"
                        saveRatingToFirestore(rating: "up")
                    }) {
                        Image(systemName: "hand.thumbsup.fill")
                            .foregroundColor(rating == "up" ? .green : .gray)
                            .font(.largeTitle)
                    }

                    Button(action: {
                        rating = "down"
                        saveRatingToFirestore(rating: "down")
                    }) {
                        Image(systemName: "hand.thumbsdown.fill")
                            .foregroundColor(rating == "down" ? .red : .gray)
                            .font(.largeTitle)
                    }
                }
                
                // Favorite Button
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isFavorited.toggle()
                    }
                    if isFavorited {
                        saveFavoriteToFirestore()
                    }
                }) {
                    HStack {
                        Image(systemName: isFavorited ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .scaleEffect(isFavorited ? 1.2 : 1.0)
                        Text(isFavorited ? "Favorited!" : "Favorite this quote")
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding(.top, 15)
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
            saveMessageToHistory(message: newMessage) // Save to Firestore history
        } else {
            generatedMessage = "No new messages available. Try again later!"
        }

        rating = nil // Reset rating when a new message is generated
        isFavorited = false // Reset favorite state when a new message is generated
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
    
    // MARK: - Firestore Functions
    
    /// Saves the user's rating to Firestore
    func saveRatingToFirestore(rating: String) {
        guard let userEmail = authManager.userEmail else {
            print("Error: No user email available")
            return
        }
        
        // Create a custom document ID using timestamp
        let timestamp = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let timestampString = dateFormatter.string(from: timestamp)
        
        // Custom document ID: email_category_timestamp
        let documentID = "\(UUID().uuidString.prefix(8))_\(categoryName)_\(timestampString)"
        
        let ratingData: [String: Any] = [
            "userEmail": userEmail,
            "category": categoryName,
            "message": generatedMessage,
            "rating": rating, // "up" or "down"
            "timestamp": Timestamp(date: timestamp)
        ]
        
        // Save to Firestore with custom document ID
        db.collection("ratings").document(documentID).setData(ratingData) { error in
            if let error = error {
                print("Error saving rating: \(error.localizedDescription)")
            } else {
                print("Rating saved successfully with ID: \(documentID)")
            }
        }
        
        // Also update the rating in message history
        updateMessageHistoryRating(rating: rating)
    }
    
    /// Update the rating for the most recent message in history
    func updateMessageHistoryRating(rating: String) {
        guard let userEmail = authManager.userEmail else {
            return
        }
        
        // Find the most recent message for this user in this category
        db.collection("messageHistory")
            .whereField("userEmail", isEqualTo: userEmail)
            .whereField("category", isEqualTo: categoryName)
            .whereField("message", isEqualTo: generatedMessage)
            .order(by: "timestamp", descending: true)
            .limit(to: 1)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error finding message to update: \(error.localizedDescription)")
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    print("No matching message found in history")
                    return
                }
                
                // Update the rating field
                self.db.collection("messageHistory").document(document.documentID).updateData([
                    "rating": rating
                ]) { error in
                    if let error = error {
                        print("Error updating rating in history: \(error.localizedDescription)")
                    } else {
                        print("Rating updated in message history")
                    }
                }
            }
    }
    
    /// Saves the current message as a favorite to Firestore
    func saveFavoriteToFirestore() {
        guard let userEmail = authManager.userEmail else {
            print("Error: No user email available")
            return
        }
        
        // Don't save the default message
        if generatedMessage == "Tap 'Generate' to get a message!" {
            print("No message to favorite yet!")
            return
        }
        
        // Create a custom document ID using timestamp
        let timestamp = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let timestampString = dateFormatter.string(from: timestamp)
        
        // Custom document ID
        let documentID = "\(UUID().uuidString.prefix(8))_\(categoryName)_\(timestampString)"
        
        let favoriteData: [String: Any] = [
            "userEmail": userEmail,
            "category": categoryName,
            "message": generatedMessage,
            "timestamp": Timestamp(date: timestamp)
        ]
        
        // Save to Firestore under "favorites" collection
        db.collection("favorites").document(documentID).setData(favoriteData) { error in
            if let error = error {
                print("Error saving favorite: \(error.localizedDescription)")
            } else {
                print("Favorite saved successfully with ID: \(documentID)")
            }
        }
    }
    
    /// Saves the generated message to message history in Firestore
    func saveMessageToHistory(message: String) {
        guard let userEmail = authManager.userEmail else {
            print("Error: No user email available")
            return
        }
        
        // Create a custom document ID using timestamp
        let timestamp = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let timestampString = dateFormatter.string(from: timestamp)
        
        // Custom document ID
        let documentID = "\(UUID().uuidString.prefix(8))_\(categoryName)_\(timestampString)"
        
        let historyData: [String: Any] = [
            "userEmail": userEmail,
            "category": categoryName,
            "message": message,
            "timestamp": Timestamp(date: timestamp),
            "rating": NSNull() // Will be updated if user rates it
        ]
        
        // Save to Firestore under "messageHistory" collection
        db.collection("messageHistory").document(documentID).setData(historyData) { error in
            if let error = error {
                print("Error saving message to history: \(error.localizedDescription)")
            } else {
                print("Message saved to history with ID: \(documentID)")
            }
        }
    }
}

#Preview {
    CategoryView(categoryName: "Motivation")
        .environmentObject(AuthManager())
}
