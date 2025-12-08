//
//  LoginView.swift
//  EncourageApp
//
//  Created by Giannfranco Crovetto on 12/17/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
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
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthManager())
}
