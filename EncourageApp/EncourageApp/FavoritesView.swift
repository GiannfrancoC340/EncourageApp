//
//  FavoritesView.swift
//  EncourageApp
//
//  Created by Giannfranco Crovetto on 12/21/25.
//

import SwiftUI
import FirebaseFirestore

// Model for Favorite quotes
struct FavoriteQuote: Identifiable {
    let id: String
    let category: String
    let message: String
    let timestamp: Date
}

struct FavoritesView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var favorites: [FavoriteQuote] = []
    @State private var isLoading = true
    
    let db = Firestore.firestore()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Centered Title
                Text("Favorites")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                
                if isLoading {
                    // Loading state
                    ProgressView("Loading favorites...")
                        .padding()
                } else if favorites.isEmpty {
                    // Empty state
                    VStack(spacing: 20) {
                        Image(systemName: "star.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No favorites yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Tap the star button on any quote to save it here!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .padding()
                } else {
                    // List of favorites
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(favorites) { favorite in
                                FavoriteCard(favorite: favorite, onDelete: {
                                    deleteFavorite(favorite)
                                })
                            }
                        }
                        .padding()
                        .padding(.bottom, 60) // Space for tab bar
                    }
                }
            }
            .onAppear {
                loadFavorites()
            }
        }
    }
    
    // Load favorites from Firestore
    func loadFavorites() {
        guard let userEmail = authManager.userEmail else {
            print("Error: No user email available")
            isLoading = false
            return
        }
        
        db.collection("favorites")
            .whereField("userEmail", isEqualTo: userEmail)
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error loading favorites: \(error.localizedDescription)")
                    isLoading = false
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    isLoading = false
                    return
                }
                
                favorites = documents.compactMap { doc in
                    let data = doc.data()
                    guard let category = data["category"] as? String,
                          let message = data["message"] as? String,
                          let timestamp = data["timestamp"] as? Timestamp else {
                        return nil
                    }
                    
                    return FavoriteQuote(
                        id: doc.documentID,
                        category: category,
                        message: message,
                        timestamp: timestamp.dateValue()
                    )
                }
                
                isLoading = false
            }
    }
    
    // Delete a favorite from Firestore
    func deleteFavorite(_ favorite: FavoriteQuote) {
        db.collection("favorites").document(favorite.id).delete { error in
            if let error = error {
                print("Error deleting favorite: \(error.localizedDescription)")
            } else {
                print("Favorite deleted successfully")
                // Remove from local array
                favorites.removeAll { $0.id == favorite.id }
            }
        }
    }
}

// Card component for each favorite
struct FavoriteCard: View {
    let favorite: FavoriteQuote
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header with category and delete button
            HStack {
                // Category badge
                let style = CategoryStyle.getStyle(for: favorite.category)
                HStack(spacing: 8) {
                    Image(systemName: style.icon)
                        .font(.system(size: 14))
                        .foregroundColor(style.color)
                    
                    Text(favorite.category)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(style.color)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(style.color.opacity(0.15))
                .cornerRadius(8)
                
                Spacer()
                
                // Delete button
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .font(.system(size: 16))
                }
            }
            
            // Quote message
            Text(favorite.message)
                .font(.body)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .lineSpacing(4)
            
            // Timestamp
            Text(formatDate(favorite.timestamp))
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    FavoritesView()
        .environmentObject(AuthManager())
}
