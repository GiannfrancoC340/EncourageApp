//
//  LoginView.swift
//  EncourageApp
//
//  Created by Giannfranco Crovetto on 12/17/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager // Use @EnvironmentObject
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack {
            Spacer()
            // Title
            Text("Encourage")
                .font(.largeTitle)

            // Email + password fields
            VStack {
                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never) // Disable auto-capitalization
                    .autocorrectionDisabled(true)       // Disable auto-correction
                    .keyboardType(.emailAddress)        // Optional: Set keyboard type for email input
                    .padding()
                    .textFieldStyle(.roundedBorder)

                SecureField("Password", text: $password)
                    .padding()
                    .textFieldStyle(.roundedBorder)
            }
            .textFieldStyle(.roundedBorder)
            .padding(40)

            // Sign up + Login buttons
            HStack {
                Button("Sign Up") {
                    authManager.signUp(email: email, password: password)
                }
                .buttonStyle(.borderedProminent)

                Button("Login") {
                    authManager.signIn(email: email, password: password)
                }
                .buttonStyle(.bordered)
            }
            
            // Reset password
            VStack(spacing: 10) {
                Text("Forgot your password?")
                    .font(.headline)
                    .padding(.top, 30)
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
                .padding(.bottom, 30)
            }
            
            Spacer()
            
//            // Name and Z-number
//            VStack(spacing: 10) {
//                Text("""
//            Built by: Giannfranco Crovetto
//            Z-number: Z23622354
//            """)
//                .font(.footnote)
//                .padding(.top)
//            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Reset Password"), message: Text(alertMessage), dismissButton: .default(Text("OK"))) // Alert
        }
        .padding()
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthManager()) // Pass AuthManager for preview
}
