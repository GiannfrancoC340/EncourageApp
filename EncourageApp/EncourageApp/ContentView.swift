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
                Text("Welcome to Encourage!")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .fontWeight(.bold)
                    .padding(.top)
                Text("Categories:")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // Scrollable body
                ScrollView(.vertical) {
                    // Rounded rectangles
                    VStack(spacing: 14) {
                        // Category 1
                        NavigationLink(destination: CategoryView(categoryName: "Motivation")) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(.systemGray6)) // Light gray background
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5) // Creates a shadow underlay
                                    .frame(width: 350, height: 100) // Adjust the width and height
                                    .padding(.horizontal)
                                Text("Motivation")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                        }
                        
                        // Category 2
                        NavigationLink(destination: CategoryView(categoryName: "Mindfulness")) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(.systemGray6)) // Light gray background
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5) // Creates a shadow underlay
                                    .frame(width: 350, height: 100) // Adjust the width and height
                                    .padding(.horizontal)
                                Text("Mindfulness")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                        }
                        
                        // Category 3
                        NavigationLink(destination: CategoryView(categoryName: "Anxiety")) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(.systemGray6)) // Light gray background
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5) // Creates a shadow underlay
                                    .frame(width: 350, height: 100) // Adjust the width and height
                                    .padding(.horizontal)
                                Text("Anxiety")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                        }
                        
                        // Category 4
                        NavigationLink(destination: CategoryView(categoryName: "Depression")) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(.systemGray6)) // Light gray background
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5) // Creates a shadow underlay
                                    .frame(width: 350, height: 100) // Adjust the width and height
                                    .padding(.horizontal)
                                Text("Depression")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                        }
                        
                        // Category 5
                        NavigationLink(destination: CategoryView(categoryName: "Overthinking")) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(.systemGray6)) // Light gray background
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5) // Creates a shadow underlay
                                    .frame(width: 350, height: 100) // Adjust the width and height
                                    .padding(.horizontal)
                                Text("Overthinking")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                        }
                        
                        // Category 6
                        NavigationLink(destination: CategoryView(categoryName: "Wellness")) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(.systemGray6)) // Light gray background
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5) // Creates a shadow underlay
                                    .frame(width: 350, height: 100) // Adjust the width and height
                                    .padding(.horizontal)
                                Text("Wellness")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                        }
                        
                        // Category 7
                        NavigationLink(destination: CategoryView(categoryName: "Inspiration")) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(.systemGray6)) // Light gray background
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5) // Creates a shadow underlay
                                    .frame(width: 350, height: 100) // Adjust the width and height
                                    .padding(.horizontal)
                                Text("Inspiration")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                        }
                        
                        // Add more categories here...
                        Spacer()
                        
                    }
                    
                    // Settings Button
                    HStack {
                        NavigationLink(destination: SettingsView()) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray5)) // Light gray background
                                    .frame(width: 50, height: 50) // Adjust size of the rectangle
                                Image(systemName: "gearshape.fill") // Gear icon
                                    .resizable()
                                    .frame(width: 30, height: 30) // Adjust size
                                    .foregroundStyle(.gray) // Icon color
                                    .padding(10)
                            }
                        }
                    }
                    .padding(.bottom, 40)
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
