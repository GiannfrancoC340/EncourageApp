//
//  MessageHistoryView.swift
//  EncourageApp
//
//  Created by Giannfranco Crovetto on 4/20/26.
//

import SwiftUI
import FirebaseFirestore
 
// Model for Message History
struct HistoryMessage: Identifiable {
    let id: String
    let category: String
    let message: String
    let timestamp: Date
    let rating: String? // "up", "down", or nil
}
 
struct MessageHistoryView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var messages: [HistoryMessage] = []
    @State private var isLoading = true
    
    let db = Firestore.firestore()
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Text("Message History")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 15)
            
            Divider()
            
            if isLoading {
                // Loading state
                ProgressView("Loading history...")
                    .padding()
                    .frame(maxHeight: .infinity)
            } else if messages.isEmpty {
                // Empty state
                VStack(spacing: 15) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    
                    Text("No messages yet")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text("Generate your first quote to see it here!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .frame(maxHeight: .infinity)
            } else {
                // List of messages
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(messages) { message in
                            MessageHistoryCard(message: message)
                        }
                    }
                    .padding()
                }
                .frame(height: 350) // Fixed height to show ~3 messages
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .frame(height: 420) // Total fixed height for the entire section
        .onAppear {
            loadMessageHistory()
        }
    }
    
    /// Load message history from Firestore
    func loadMessageHistory() {
        guard let userEmail = authManager.userEmail else {
            print("Error: No user email available")
            isLoading = false
            return
        }
        
        db.collection("messageHistory")
            .whereField("userEmail", isEqualTo: userEmail)
            .order(by: "timestamp", descending: true)
            .limit(to: 50) // Show last 50 messages
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error loading message history: \(error.localizedDescription)")
                    isLoading = false
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    isLoading = false
                    return
                }
                
                messages = documents.compactMap { doc in
                    let data = doc.data()
                    guard let category = data["category"] as? String,
                          let message = data["message"] as? String,
                          let timestamp = data["timestamp"] as? Timestamp else {
                        return nil
                    }
                    
                    // Rating might be nil or NSNull
                    var rating: String? = nil
                    if let ratingValue = data["rating"] as? String {
                        rating = ratingValue
                    }
                    
                    return HistoryMessage(
                        id: doc.documentID,
                        category: category,
                        message: message,
                        timestamp: timestamp.dateValue(),
                        rating: rating
                    )
                }
                
                isLoading = false
            }
    }
}
 
// Card component for each message in history
struct MessageHistoryCard: View {
    let message: HistoryMessage
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header with category and rating
            HStack {
                // Category badge
                let style = CategoryStyle.getStyle(for: message.category)
                HStack(spacing: 6) {
                    Image(systemName: style.icon)
                        .font(.system(size: 12))
                        .foregroundColor(style.color)
                    
                    Text(message.category)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(style.color)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(style.color.opacity(0.15))
                .cornerRadius(6)
                
                Spacer()
                
                // Rating indicator
                if let rating = message.rating {
                    Image(systemName: rating == "up" ? "hand.thumbsup.fill" : "hand.thumbsdown.fill")
                        .font(.system(size: 14))
                        .foregroundColor(rating == "up" ? .green : .red)
                }
            }
            
            // Message text
            Text(message.message)
                .font(.subheadline)
                .foregroundColor(.primary)
                .lineLimit(3)
                .lineSpacing(2)
            
            // Timestamp
            Text(formatDate(message.timestamp))
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
 
#Preview {
    MessageHistoryView()
        .environmentObject(AuthManager())
        .padding()
}
