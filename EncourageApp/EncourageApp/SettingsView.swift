//
//  SettingsView.swift
//  EncourageApp
//
//  Created by Giannfranco Crovetto on 12/18/24.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 20) {
                
                // App Version section
                VStack(alignment: .leading, spacing: 10) {
                    Text("App Version")
                        .font(.headline)
                    Text("1.0.0")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                
                // Default Language section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Default language")
                        .font(.headline)
                    Text("English")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }

                // API Documents section
                VStack(alignment: .leading, spacing: 10) {
                    Text("API Documents")
                        .font(.headline)
                    Text("""
                - The API that I used is called ExchangeRate-API.
                
                https://api.exchangerate-api.com/v4/latest/USD
                """)
                    .font(.body)
                    .padding(.leading)
                }
                
                // Developer Notes section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Developer Notes")
                        .font(.headline)
                    Text("""
                - Initial version of the Encourage app
                - Features include category views, mood tracker, and profile view.
                """)
                    .font(.body)
                    .padding(.leading)
                }
                
                // Changelog section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Changelog")
                        .font(.headline)
                    Text("""
                - Initial version, Changelog coming soon!
                """)
                    .font(.body)
                    .padding(.leading)
                }
                
                // Author section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Author")
                        .font(.headline)
                    Text("""
                Built by: Giannfranco Crovetto
                Z-number: Z23622354
                """)
                    .font(.body)
                    .padding(.leading)
                }
                    
                // About the App section
                VStack(alignment: .leading, spacing: 10) {
                    Text("About the App")
                        .font(.headline)
                    Text("""
                This app – Encourage - is an app
                """)
                    .font(.body)
                    .padding(.leading)
                }
            }
            .padding()
            .padding(.bottom, 48) // Add extra padding for the tab bar height
            .navigationTitle("Settings") // Navigation title
        }
    }
}

#Preview {
    SettingsView()
}

