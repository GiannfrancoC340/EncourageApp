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
                // Sections
                VStack(alignment: .leading, spacing: 10) {
                    Text("App Version")
                        .font(.headline)
                    Text("1.0.0")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
//               .padding()
            }
            .padding()
            .padding(.bottom, 48) // Extra padding for the tab bar controller
            .navigationTitle("Settings") // Navigation Title
        }
    }
}

#Preview {
    SettingsView()
}
