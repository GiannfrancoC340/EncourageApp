//
//  ContentView.swift
//  EncourageApp
//
//  Created by Giannfranco Crovetto on 11/14/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager // Access the authManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Title
                Text("Encourage App")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // Scrollable body
                ScrollView(.vertical) {
                    // Rounded rectangle
                    VStack(spacing: 14) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemGray6)) // Light gray background
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5) // Creates a shadow underlay
                            .frame(width: 350, height: 100) // Adjust the width and height
                            .padding(.horizontal)
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemGray6)) // Light gray background
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5) // Creates a shadow underlay
                            .frame(width: 350, height: 100) // Adjust the width and height
                            .padding(.horizontal)
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemGray6)) // Light gray background
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5) // Creates a shadow underlay
                            .frame(width: 350, height: 100) // Adjust the width and height
                            .padding(.horizontal)
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemGray6)) // Light gray background
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5) // Creates a shadow underlay
                            .frame(width: 350, height: 100) // Adjust the width and height
                            .padding(.horizontal)
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemGray6)) // Light gray background
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5) // Creates a shadow underlay
                            .frame(width: 350, height: 100) // Adjust the width and height
                            .padding(.horizontal)
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemGray6)) // Light gray background
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5) // Creates a shadow underlay
                            .frame(width: 350, height: 100) // Adjust the width and height
                            .padding(.horizontal)
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemGray6)) // Light gray background
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5) // Creates a shadow underlay
                            .frame(width: 350, height: 100) // Adjust the width and height
                            .padding(.horizontal)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthManager()) // Pass an instance of AuthManager for preview
}
