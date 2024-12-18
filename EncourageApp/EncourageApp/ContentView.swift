//
//  ContentView.swift
//  EncourageApp
//
//  Created by Giannfranco Crovetto on 11/14/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("Encourage App")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            Spacer()
            
            Text("Hello there")
            
            // Footer
            Text("Created by: Giannfranco Crovetto")
                .font(.footnote)
                .padding()
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthManager()) // Pass an instance of AuthManager for preview
}
