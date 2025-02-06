//
//  CategoryView.swift
//  EncourageApp
//
//  Created by Giannfranco Crovetto on 12/18/24.
//

import SwiftUI

struct CategoryView: View {
    var categoryName: String // Pass the category name
    @State private var generatedMessage: String = "Tap 'Generate' to get a message!"

    // Sample messages for different categories
    let messages: [String: [String]] = [
        "Motivation": [
            "Believe in yourself!",
            "Keep pushing forward!",
            "Success is just around the corner!",
            "Never give up!",
            "Hard work pays off!"
        ],
        "Mindfulness": [
            "Do not dwell in the past, do not dream of the future, concentrate the mind on the present moment. ― Buddha",
            "Your vision will become clear only when you look into your heart. Who looks outside, dreams. Who looks inside, awakens. – Carl Jung",
            "Mindfulness is simply being aware of what is happening right now without wishing it were different; enjoying the pleasant without holding on when it changes (which it will); being with the unpleasant without fearing it will always be this way (which it won’t). ― James Baraz",
            "Feelings come and go like clouds in a windy sky. Conscious breathing is my anchor. ― Thich Nhat Hanh",
            "We use mindfulness to observe the way we cling to pleasant experiences & push away unpleasant ones. – Sharon Salzberg"
        ],
        "Anxiety": [
            "Everything you want is on the other side of fear. ― Jack Canfield",
            "Trust yourself. You’ve survived a lot, and you’ll survive whatever is coming. ― Robert Tew",
            "Life is like riding a bicycle. To keep your balance, you must keep moving. — Albert Einstein",
            "Do not anticipate trouble or worry about what may never happen. Keep in the sunlight. ― Benjamin Franklin",
            "The only thing we have to fear is fear itself. ― Franklin Delano Roosevelt"
        ],
        "Depression": [
            "Please remember that you’re capable, brave and loved – even when it feels like you’re not.",
            "Small, baby steps each day add up to huge, giant leaps over time. So, please keep going.",
            "You are not worthless, you are not a failure, and you are not a loser. That voice saying you are is just your depression trying to trick you.",
            "Perhaps the butterfly is proof that you can go through a great deal of darkness yet become something beautiful again.",
            "Don’t dwell on those who hold you down. Instead, cherish those who helped you up."
        ],
        "Overthinking": [
            "You don’t have to see the whole staircase, just take the first step. ― Martin Luther King Jr.",
            "To think too much is a disease. ― Fyodor Dostoyevsky",
            "Sometimes you can’t calm the storm, so it’s best to stop trying. What you can do is calm yourself. The storm will pass. ― Timber Hawkeye",
            "Don’t get too deep, it leads to overthinking, and overthinking leads to problems that don’t even exist in the first place. ― Jayson Engay",
            "There is hope, even when your brain tells you there isn’t. - John Green"
        ],
        "Wellness": [
            "Take care of your mind and body.",
            "Rest and self-care are so important.",
            "A healthy mind brings a healthy life.",
            "Breathe deeply and embrace the moment.",
            "You deserve time for yourself."
        ],
        "Inspiration": [
            "Dream big and dare to fail.",
            "The best time for new beginnings is now.",
            "Your potential is limitless.",
            "Every day is a second chance.",
            "Inspiration exists, but it has to find you working."
        ],
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Category: \(categoryName)")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            // Generate Button
            Button(action: generateMessage) {
                Text("Generate")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()
                    .frame(width: 200)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            // Message Display Box
            Text(generatedMessage)
                .frame(width: 300, height: 190)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 3)
                .multilineTextAlignment(.center)
        }
        .padding()
        .navigationTitle("Category View")
    }
    
    // Function to generate a random message
    func generateMessage() {
        if let categoryMessages = messages[categoryName] {
            generatedMessage = categoryMessages.randomElement() ?? "No messages available."
        } else {
            generatedMessage = "No messages found for this category."
        }
    }
}

#Preview {
    CategoryView(categoryName: "Motivation") // Example category
}
