//
//  LoginView.swift
//  EncourageApp
//
//  Created by Giannfranco Crovetto on 12/17/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager // Use @EnvironmentObject

    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack {
            Text("Welcome!")
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
        }
        .padding()
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthManager()) // Pass AuthManager for preview
}
