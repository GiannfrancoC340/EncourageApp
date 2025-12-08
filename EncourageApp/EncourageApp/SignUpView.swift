//
//  SignUpView.swift
//  EncourageApp
//
//  Created by Giannfranco Crovetto on 12/8/25.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""

    var body: some View {
        VStack {
            Spacer()
            
            // Title
            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Join Encourage today!")
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
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
            .padding(.top, 30)

            // Sign Up button
            Button(action: {
                // Validate passwords match
                if password != confirmPassword {
                    alertMessage = "Passwords do not match."
                    showAlert = true
                } else if password.count < 6 {
                    alertMessage = "Password must be at least 6 characters."
                    showAlert = true
                } else if email.isEmpty {
                    alertMessage = "Please enter an email address."
                    showAlert = true
                } else {
                    authManager.signUp(email: email, password: password)
                }
            }) {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
            .padding(.top, 20)
            
            Spacer()
            
            // Navigation back to Login
            HStack {
                Text("Already have an account?")
                    .foregroundColor(.gray)
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Login")
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
            }
            .padding(.bottom, 30)
        }
        .navigationBarBackButtonHidden(false)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Sign Up"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    NavigationView {
        SignUpView()
            .environmentObject(AuthManager())
    }
}
