//
//  LoginView.swift
//  EncourageApp
//
//  Created by Giannfranco Crovetto on 12/17/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                // Title
                Text("Encourage")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Welcome Back!")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .padding(.top, 5)

                // Email + password fields
                VStack(spacing: 15) {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)
                .padding(.top, 30)

                // Login button
                Button(action: {
                    authManager.signIn(email: email, password: password)
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)
                .padding(.top, 20)
                
                // Forgot password
                Button("Forgot Password?") {
                    if email.isEmpty {
                        alertMessage = "Please enter your email address first."
                        showAlert = true
                    } else {
                        authManager.resetPassword(email: email) { result in
                            switch result {
                            case .success:
                                alertMessage = "Password reset email sent to \(email)."
                            case .failure(let error):
                                alertMessage = error.localizedDescription
                            }
                            showAlert = true
                        }
                    }
                }
                .font(.subheadline)
                .foregroundColor(.blue)
                .padding(.top, 15)
                
                Spacer()
                
                // Navigation to Sign Up
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.gray)
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign Up")
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.bottom, 30)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Password Reset"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthManager())
}
