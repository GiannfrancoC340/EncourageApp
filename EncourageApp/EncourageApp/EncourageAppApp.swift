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
    init() { // <-- Add an init
        FirebaseApp.configure() // <-- Configure Firebase app
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
