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
        VStack(spacing: 20) {
            // Title
            Text("Profile")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            // Shows if the user is signed in
            VStack(spacing: 20) {
                if let email = authManager.user?.email {
                    Text("Signed in as:")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text(email)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding()
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
            .padding(.top, 20)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Profile")
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthManager(isMocked: true)) // Mocked for preview
}
