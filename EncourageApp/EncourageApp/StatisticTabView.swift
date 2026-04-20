//
//  StatisticTabView.swift
//  EncourageApp
//
//  Created by Giannfranco Crovetto on 4/20/26.
//

import SwiftUI

struct StatisticsTabView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Title
                Text("Statistics")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top)
                
                // 1. Streak Counter
                StreakCounterView()
                    .padding(.horizontal)
                
                // 2. Statistics (This Week / All Time)
                StatisticsView()
                    .padding(.horizontal)
                
                // 3. Message History
                MessageHistoryView()
                    .padding(.horizontal)
                
                // 4. Favorites
                FavoritesScrollView()
                    .padding(.horizontal)
                
                // 5. Most-Used Categories
                MostUsedCategoriesView()
                    .padding(.horizontal)
                
                Spacer()
            }
            .padding(.bottom, 80) // Extra padding for tab bar
        }
    }
}
 
#Preview {
    StatisticsTabView()
        .environmentObject(AuthManager())
}
