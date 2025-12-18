//
//  SplashScreen.swift
//  EncourageApp
//
//  Created by Giannfranco Crovetto on 12/17/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var opacity = 0.0
    @State private var scale = 0.8
    
    var body: some View {
        if isActive {
            // Navigate to main content after splash
            ContentViewWrapper()
        } else {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // App icon or logo
                    Image(systemName: "sun.max.circle.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.white)
                        .scaleEffect(scale)
                    
                    // App name
                    Text("Encourage")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    // Tagline
                    Text("Your daily dose of encouragement")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                }
                .opacity(opacity)
            }
            .onAppear {
                // Animate in
                withAnimation(.easeIn(duration: 0.8)) {
                    opacity = 1.0
                    scale = 1.0
                }
                
                // Transition to main app after delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        isActive = true
                    }
                }
            }
        }
    }
}

// Wrapper to connect to your existing app structure
struct ContentViewWrapper: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        if authManager.isSignedIn {
            MainTabView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    SplashScreenView()
        .environmentObject(AuthManager())
}
