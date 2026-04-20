//
//  StreakCounterView.swift
//  EncourageApp
//
//  Created by Giannfranco Crovetto on 4/20/26.
//

import SwiftUI
import FirebaseFirestore
 
struct StreakCounterView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var currentStreak = 0
    @State private var longestStreak = 0
    @State private var isLoading = true
    
    let db = Firestore.firestore()
    
    var body: some View {
        VStack(spacing: 0) {
            if isLoading {
                // Loading state
                ProgressView("Loading streak...")
                    .padding()
                    .frame(height: 150)
            } else {
                VStack(spacing: 15) {
                    // Flame icon and current streak
                    HStack(spacing: 10) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.orange)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Current Streak")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text("\(currentStreak) \(currentStreak == 1 ? "Day" : "Days")")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.primary)
                        }
                    }
                    
                    // Motivational message
                    Text(getStreakMessage())
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Longest streak
                    HStack {
                        Image(systemName: "trophy.fill")
                            .foregroundColor(.yellow)
                        
                        Text("Longest Streak:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("\(longestStreak) \(longestStreak == 1 ? "day" : "days")")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 15)
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .onAppear {
            loadStreak()
        }
    }
    
    /// Load streak data from Firestore
    func loadStreak() {
        guard let userEmail = authManager.userEmail else {
            print("Error: No user email available")
            isLoading = false
            return
        }
        
        // Get user document
        db.collection("users").document(userEmail).getDocument { snapshot, error in
            if let error = error {
                print("Error loading streak: \(error.localizedDescription)")
                // If document doesn't exist, initialize streak
                initializeStreak()
                return
            }
            
            if let data = snapshot?.data() {
                // Document exists, load streak data
                currentStreak = data["streakCount"] as? Int ?? 0
                longestStreak = data["longestStreak"] as? Int ?? 0
                
                // Update streak based on last login
                if let lastLoginDate = data["lastLoginDate"] as? String {
                    updateStreak(lastLoginDate: lastLoginDate)
                } else {
                    // No last login date, update it
                    updateStreak(lastLoginDate: nil)
                }
            } else {
                // Document doesn't exist, create it
                initializeStreak()
            }
            
            isLoading = false
        }
    }
    
    /// Initialize streak for new users
    func initializeStreak() {
        guard let userEmail = authManager.userEmail else { return }
        
        let today = getDateString(Date())
        
        let userData: [String: Any] = [
            "lastLoginDate": today,
            "streakCount": 1,
            "longestStreak": 1
        ]
        
        db.collection("users").document(userEmail).setData(userData) { error in
            if let error = error {
                print("Error initializing streak: \(error.localizedDescription)")
            } else {
                print("Streak initialized")
                currentStreak = 1
                longestStreak = 1
            }
        }
        
        isLoading = false
    }
    
    /// Update streak based on last login date
    func updateStreak(lastLoginDate: String?) {
        guard let userEmail = authManager.userEmail else { return }
        
        let today = getDateString(Date())
        let yesterday = getDateString(Date().addingTimeInterval(-24 * 60 * 60))
        
        // Check login pattern
        if lastLoginDate == today {
            // Already logged in today, no update needed
            print("Already logged in today, streak unchanged")
            return
        } else if lastLoginDate == yesterday {
            // Logged in yesterday, increment streak
            currentStreak += 1
            
            // Update longest streak if needed
            if currentStreak > longestStreak {
                longestStreak = currentStreak
            }
            
            print("Consecutive login! Streak: \(currentStreak)")
        } else {
            // Broke the streak, reset to 1
            currentStreak = 1
            print("Streak broken, reset to 1")
        }
        
        // Update Firestore
        let updates: [String: Any] = [
            "lastLoginDate": today,
            "streakCount": currentStreak,
            "longestStreak": longestStreak
        ]
        
        db.collection("users").document(userEmail).updateData(updates) { error in
            if let error = error {
                print("Error updating streak: \(error.localizedDescription)")
            } else {
                print("Streak updated successfully")
            }
        }
    }
    
    /// Get motivational message based on streak
    func getStreakMessage() -> String {
        if currentStreak == 0 {
            return "Start your streak today!"
        } else if currentStreak == 1 {
            return "Great start! Come back tomorrow to continue!"
        } else if currentStreak < 7 {
            return "Keep it up! You're building a habit!"
        } else if currentStreak < 30 {
            return "Amazing! You're on a roll! 🔥"
        } else {
            return "Incredible dedication! Keep going! 🌟"
        }
    }
    
    /// Convert Date to String (YYYY-MM-DD format)
    func getDateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
 
#Preview {
    StreakCounterView()
        .environmentObject(AuthManager())
        .padding()
}
