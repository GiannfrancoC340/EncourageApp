//
//  ProfileView.swift
//  EncourageApp
//
//  Created by Giannfranco Crovetto on 12/17/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager // Use AuthManager to get email
    @State private var showAlert = false
    @State private var alertMessage = ""
    
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
                    Text("Signed in as: \(email)")
                        .font(.title2)
                        .padding()
                    
                    // Reset the password
                    Button("Reset Password") {
                        authManager.resetPassword(email: email) { result in
                            switch result {
                            case .success:
                                alertMessage = "Password reset email sent to \(email)." // Pop up message
                            case .failure(let error):
                                alertMessage = error.localizedDescription
                            }
                            showAlert = true
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 20)
                } else {
                    Text("Not signed in") // Shows if the user is not signed in
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
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Reset Password"), message: Text(alertMessage), dismissButton: .default(Text("OK"))) // Alert
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthManager(isMocked: true)) // Mocked for preview
}
