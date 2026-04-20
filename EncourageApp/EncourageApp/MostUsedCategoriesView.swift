//
//  MostUsedCategoriesView.swift
//  EncourageApp
//
//  Created by Giannfranco Crovetto on 4/20/26.
//

import SwiftUI
import FirebaseFirestore
 
struct CategoryUsage: Identifiable {
    let id = UUID()
    let category: String
    let count: Int
    let percentage: Double
}
 
struct MostUsedCategoriesView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var categories: [CategoryUsage] = []
    @State private var isLoading = true
    @State private var isExpanded = false // Track if showing all categories
    
    let db = Firestore.firestore()
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Text("Your Top Categories")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 15)
            
            Divider()
            
            if isLoading {
                // Loading state
                ProgressView("Loading categories...")
                    .padding()
                    .frame(height: 200)
            } else if categories.isEmpty {
                // Empty state
                VStack(spacing: 15) {
                    Image(systemName: "chart.bar")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    
                    Text("No data yet")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text("Generate messages to see your top categories!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .frame(height: 200)
            } else {
                // List of categories
                VStack(spacing: 12) {
                    // Show top 5 or all categories based on isExpanded
                    let displayCategories = isExpanded ? categories : Array(categories.prefix(5))
                    
                    ForEach(Array(displayCategories.enumerated()), id: \.element.id) { index, category in
                        CategoryUsageRow(
                            rank: index + 1,
                            category: category.category,
                            count: category.count,
                            percentage: category.percentage
                        )
                    }
                    
                    // View More / View Less button
                    if categories.count > 5 {
                        Button(action: {
                            withAnimation {
                                isExpanded.toggle()
                            }
                        }) {
                            HStack {
                                Text(isExpanded ? "View Less" : "View More")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                
                                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                    .font(.system(size: 12))
                            }
                            .foregroundColor(.blue)
                            .padding(.top, 8)
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .onAppear {
            loadMostUsedCategories()
        }
    }
    
    /// Load category usage from Firestore
    func loadMostUsedCategories() {
        guard let userEmail = authManager.userEmail else {
            print("Error: No user email available")
            isLoading = false
            return
        }
        
        db.collection("messageHistory")
            .whereField("userEmail", isEqualTo: userEmail)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error loading categories: \(error.localizedDescription)")
                    isLoading = false
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    isLoading = false
                    return
                }
                
                // Count messages per category
                var categoryCounts: [String: Int] = [:]
                for doc in documents {
                    if let category = doc.data()["category"] as? String {
                        categoryCounts[category, default: 0] += 1
                    }
                }
                
                // Find the max count for percentage calculation
                let maxCount = categoryCounts.values.max() ?? 1
                
                // Convert to CategoryUsage objects and sort
                categories = categoryCounts.map { category, count in
                    CategoryUsage(
                        category: category,
                        count: count,
                        percentage: (Double(count) / Double(maxCount)) * 100
                    )
                }
                .sorted { $0.count > $1.count } // Sort by count descending
                // Store all categories (not limited to 5)
                
                isLoading = false
            }
    }
}
 
// Row component for each category
struct CategoryUsageRow: View {
    let rank: Int
    let category: String
    let count: Int
    let percentage: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Rank, icon, category name, and count
            HStack(spacing: 10) {
                // Rank number
                Text("\(rank).")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .frame(width: 25, alignment: .leading)
                
                // Category icon and name
                let style = CategoryStyle.getStyle(for: category)
                HStack(spacing: 8) {
                    Image(systemName: style.icon)
                        .font(.system(size: 18))
                        .foregroundColor(style.color)
                    
                    Text(category)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                // Message count
                Text("\(count) msg\(count == 1 ? "" : "s")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background bar
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray5))
                        .frame(height: 8)
                    
                    // Filled bar
                    let style = CategoryStyle.getStyle(for: category)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(style.color)
                        .frame(width: geometry.size.width * (percentage / 100), height: 8)
                }
            }
            .frame(height: 8)
            
            // Percentage text
            Text("\(Int(percentage))%")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}
 
#Preview {
    MostUsedCategoriesView()
        .environmentObject(AuthManager())
        .padding()
}
