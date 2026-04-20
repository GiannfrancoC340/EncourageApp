//
//  StatisticsView.swift
//  EncourageApp
//
//  Created by Giannfranco Crovetto on 4/20/26.
//

import SwiftUI
import FirebaseFirestore
 
struct StatisticsView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var weeklyMessages = 0
    @State private var weeklyFavorites = 0
    @State private var positiveRatingPercentage = 0
    @State private var totalMessages = 0
    @State private var mostUsedCategory = "None"
    @State private var isLoading = true
    
    let db = Firestore.firestore()
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Text("Your Stats")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 15)
            
            Divider()
            
            if isLoading {
                // Loading state
                ProgressView("Loading stats...")
                    .padding()
                    .frame(height: 250)
            } else {
                VStack(spacing: 20) {
                    // This Week Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("This Week")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        VStack(spacing: 10) {
                            StatRow(icon: "chart.bar.fill", color: .blue, label: "Messages generated", value: "\(weeklyMessages)")
                            StatRow(icon: "star.fill", color: .yellow, label: "Favorites saved", value: "\(weeklyFavorites)")
                            StatRow(icon: "hand.thumbsup.fill", color: .green, label: "Positive ratings", value: "\(positiveRatingPercentage)%")
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // All Time Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("All Time")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        VStack(spacing: 10) {
                            StatRow(icon: "chart.line.uptrend.xyaxis", color: .purple, label: "Total messages", value: "\(totalMessages)")
                            StatRow(icon: "trophy.fill", color: .orange, label: "Most active", value: mostUsedCategory)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding()
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .onAppear {
            loadStatistics()
        }
    }
    
    /// Load all statistics from Firestore
    func loadStatistics() {
        guard let userEmail = authManager.userEmail else {
            print("Error: No user email available")
            isLoading = false
            return
        }
        
        let group = DispatchGroup()
        
        // Calculate start of current week (Monday at midnight)
        let startOfWeek = getStartOfWeek()
        
        // 1. Get weekly messages count
        group.enter()
        db.collection("messageHistory")
            .whereField("userEmail", isEqualTo: userEmail)
            .whereField("timestamp", isGreaterThanOrEqualTo: Timestamp(date: startOfWeek))
            .getDocuments { snapshot, error in
                if let documents = snapshot?.documents {
                    weeklyMessages = documents.count
                }
                group.leave()
            }
        
        // 2. Get weekly favorites count
        group.enter()
        db.collection("favorites")
            .whereField("userEmail", isEqualTo: userEmail)
            .whereField("timestamp", isGreaterThanOrEqualTo: Timestamp(date: startOfWeek))
            .getDocuments { snapshot, error in
                if let documents = snapshot?.documents {
                    weeklyFavorites = documents.count
                }
                group.leave()
            }
        
        // 3. Get all ratings to calculate positive percentage
        group.enter()
        db.collection("ratings")
            .whereField("userEmail", isEqualTo: userEmail)
            .getDocuments { snapshot, error in
                if let documents = snapshot?.documents {
                    let ratings = documents.compactMap { $0.data()["rating"] as? String }
                    let upvotes = ratings.filter { $0 == "up" }.count
                    let total = ratings.count
                    
                    if total > 0 {
                        positiveRatingPercentage = Int((Double(upvotes) / Double(total)) * 100)
                    } else {
                        positiveRatingPercentage = 0
                    }
                }
                group.leave()
            }
        
        // 4. Get total messages count
        group.enter()
        db.collection("messageHistory")
            .whereField("userEmail", isEqualTo: userEmail)
            .getDocuments { snapshot, error in
                if let documents = snapshot?.documents {
                    totalMessages = documents.count
                    
                    // Also calculate most used category
                    var categoryCounts: [String: Int] = [:]
                    for doc in documents {
                        if let category = doc.data()["category"] as? String {
                            categoryCounts[category, default: 0] += 1
                        }
                    }
                    
                    // Find category with highest count
                    if let topCategory = categoryCounts.max(by: { $0.value < $1.value }) {
                        mostUsedCategory = topCategory.key
                    } else {
                        mostUsedCategory = "None"
                    }
                }
                group.leave()
            }
        
        // When all queries complete, update UI
        group.notify(queue: .main) {
            isLoading = false
        }
    }
    
    /// Get the start of the current week (Monday at 00:00:00)
    func getStartOfWeek() -> Date {
        let calendar = Calendar.current
        let today = Date()
        
        // Get the current weekday (1 = Sunday, 2 = Monday, ..., 7 = Saturday)
        let weekday = calendar.component(.weekday, from: today)
        
        // Calculate days to subtract to get to Monday
        // If today is Sunday (1), we go back 6 days
        // If today is Monday (2), we go back 0 days
        // If today is Tuesday (3), we go back 1 day, etc.
        let daysToSubtract = (weekday == 1) ? 6 : (weekday - 2)
        
        // Get Monday of this week
        guard let monday = calendar.date(byAdding: .day, value: -daysToSubtract, to: today) else {
            return today
        }
        
        // Set time to midnight (00:00:00)
        let startOfMonday = calendar.startOfDay(for: monday)
        
        return startOfMonday
    }
}
 
// Reusable stat row component
struct StatRow: View {
    let icon: String
    let color: Color
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 30)
            
            // Label
            Text(label)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
            
            // Value
            Text(value)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
    }
}
 
#Preview {
    StatisticsView()
        .environmentObject(AuthManager())
        .padding()
}
