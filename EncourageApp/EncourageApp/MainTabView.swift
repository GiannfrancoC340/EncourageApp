//
//  MainTabView.swift
//  EncourageApp
//
//  Created by Giannfranco Crovetto on 12/17/24.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .contentView
    @EnvironmentObject var authManager: AuthManager // allows AuthManager access
    
    var body: some View {
        ZStack {
            // Content Area
            Group {
                // All the tabs on the controller
                switch selectedTab {
                case .contentView:
                    ContentView()
                case .profileView:
                    ProfileView()
                case .settingsView:
                    SettingsView()
                case .favoritesView:
                    FavoritesView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Custom Tab Bar
            VStack {
                Spacer()
                HStack(spacing: 0) {
                    ForEach(Tab.allCases, id: \.self) { tab in
                        Button(action: {
                            selectedTab = tab
                        }) {
                            VStack {
                                Image(systemName: tab.icon)
                                    .font(.system(size: 24))
                                Text(tab.title)
                                    .font(.caption)
                            }
                            .foregroundColor(selectedTab == tab ? .blue : .gray)
                            .frame(maxWidth: .infinity)
                            //.frame(width: 66) // Set a fixed width for all tabs
                            .padding()
                            .background(selectedTab == tab ? Color(UIColor.systemGray6) : Color.clear)
                        }
                    }
                }
                .background(Color.white)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

enum Tab: CaseIterable {
    case contentView, profileView, settingsView, favoritesView
    
    var icon: String {
        // Tab icon
        switch self {
        case .contentView: return "house"
        case .profileView: return "person"
        case .settingsView: return "gear"
        case .favoritesView: return "star"
        }
    }
    
    var title: String {
        // Tab name at the bottom
        switch self {
        case .contentView: return "Home"
        case .profileView: return "Profile"
        case .settingsView: return "Settings"
        case .favoritesView: return "Favorites"
        }
    }
}


#Preview {
    MainTabView()
        .environmentObject(AuthManager(isMocked: true)) // Mocked for preview
}
