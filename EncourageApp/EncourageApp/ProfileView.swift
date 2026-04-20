//
//  ProfileView.swift
//  EncourageApp
//
//  Created by Giannfranco Crovetto on 12/17/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager // Use AuthManager to get email
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Title
                Text("Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // Shows if the user is signed in
                VStack(spacing: 20) {
                    if let email = authManager.user?.email {
                        Text("Signed in as:")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text(email)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.bottom, 10)
                    } else {
                        Text("Not signed in")
                            .font(.title2)
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
 
                // Allows the user to sign out
                Button("Sign Out") {
                    authManager.signOut()
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 20)
                
                // Message History Section
                MessageHistoryView()
                    .padding(.horizontal)
                
                // Statistics Section
                StatisticsView()
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                Spacer()
            }
            .padding(.bottom, 80) // Extra padding for tab bar
        }
        .navigationTitle("Profile")
    }
}
 
#Preview {
    ProfileView()
        .environmentObject(AuthManager(isMocked: true)) // Mocked for preview
}
