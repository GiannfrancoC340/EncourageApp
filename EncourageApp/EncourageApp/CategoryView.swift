//
//  CategoryView.swift
//  EncourageApp
//
//  Created by Giannfranco Crovetto on 12/18/24.
//

import SwiftUI

struct CategoryView: View {
    var body: some View {
        VStack {
            Text("Congrats! You made it to this file!")
                .font(.title)
                .fontWeight(.bold)
                .padding()
        }
        .navigationTitle("Category View")
    }
}

#Preview {
    CategoryView()
}
