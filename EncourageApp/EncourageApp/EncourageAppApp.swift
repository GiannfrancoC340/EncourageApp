//
//  EncourageAppApp.swift
//  EncourageApp
//
//  Created by Giannfranco Crovetto on 11/14/24.
//

import SwiftUI
import FirebaseCore // <-- Import Firebase

@main
struct EncourageAppApp: App {
    @StateObject private var authManager = AuthManager() // Use @StateObject for AuthManager
    
    init() { // <-- Add an init
        FirebaseApp.configure() // <-- Configure Firebase app
    }
    
    var body: some Scene {
        WindowGroup {
            if authManager.isSignedIn {
                ContentView()
                    .environmentObject(authManager) // Pass as EnvironmentObject
            } else {
                LoginView()
                    .environmentObject(authManager) // Pass as EnvironmentObject
            }
        }
    }
}
