//
//  FavoritesScrollView.swift
//  EncourageApp
//
//  Created by Giannfranco Crovetto on 4/20/26.
//

import SwiftUI
import FirebaseFirestore

struct FavoritesScrollView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var favorites: [FavoriteQuote] = []
    @State private var isLoading = true
    
    let db = Firestore.firestore()
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Text("Favorites")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 15)
            
            Divider()
            
            if isLoading {
                // Loading state
                ProgressView("Loading favorites...")
                    .padding()
                    .frame(height: 200)
            } else if favorites.isEmpty {
                // Empty state
                VStack(spacing: 15) {
                    Image(systemName: "star.slash")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    
                    Text("No favorites yet")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text("Tap the star button on any quote to save it here!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .frame(height: 200)
            } else {
                // List of favorites with internal scrolling
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(favorites) { favorite in
                            FavoriteCard(favorite: favorite, onDelete: {
                                deleteFavorite(favorite)
                            })
                        }
                    }
                    .padding()
                }
                .frame(height: 350) // Fixed height to show ~3 favorites
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .frame(height: 420) // Total fixed height for the entire section
        .onAppear {
            loadFavorites()
        }
    }
    
    /// Load favorites from Firestore
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
    
    /// Delete a favorite from Firestore
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

#Preview {
    FavoritesScrollView()
        .environmentObject(AuthManager())
        .padding()
}
