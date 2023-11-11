//
//  FeedView.swift
//  learnai
//
//  Created by Aidan Witeck on 11/10/23.
//

import Foundation
import SwiftUI

struct FeedView: View {
    @State private var stories = [Story]()
    @State private var currentIndex = 0
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(stories.indices, id: \.self) { index in
                StoryView(story: stories[index])
                    .tag(index)
                    .onAppear {
                        if index == stories.count - 2 { // Load more stories when one story away from the end
                            loadMoreStories()
                        }
                    }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onAppear {
            loadMoreStories()
        }
    }
    
    private func loadMoreStories() {
        // Load more stories here
        // For now, adding dummy data for demonstration
        let newStories = [
            Story(title: "Dubai Police Fleet", content: "Dubai's police fleet includes some of the world's most luxurious and high-performance cars, such as the Bugatti Veyron, Aston Martin One-77, and Lamborghini Aventador. This extravagant fleet serves not only as patrol cars but also as a marketing tool to promote Dubai's image of luxury and opulence.", followUpQuestion: "How long has the police flet existed?", categories: ["Middle East"]),
            Story(title: "The oud", content: "The oud, a stringed instrument resembling a lute, is considered one of the most important in Middle Eastern music. Its origins can be traced back to the ancient civilizations of Mesopotamia over 3,500 years ago. The oud has played a central role in the musical traditions of the Arabian Peninsula, Persia, and the Levant, influencing musical styles and instruments across the Mediterranean, including the European lute. With a deep, resonant sound and a rich history, the oud is not just an instrument but a symbol of the cultural and musical heritage of the Middle East.", followUpQuestion: "Question 2", categories: ["Music", "Middle East"])
        ]
        stories.append(contentsOf: newStories)
    }
}
