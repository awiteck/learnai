//
//  UserInterestViewModel.swift
//  learnai
//
//  Created by Aidan Witeck on 11/10/23.
//

import Foundation
import SwiftUI

enum Interest: String, CaseIterable {
    case technologyInnovation = "Technology & Innovation"
    case globalCuisine = "Global Cuisine & Cooking"
    case scienceFiction = "Science Fiction & Fantasy"
    case worldHistory = "World History & Cultures"
    case musicProduction = "Music Production & Theory"
    case artificialIntelligence = "Artificial Intelligence & Robotics"
    case sustainability = "Sustainability & Environment"
    case fitnessWellness = "Fitness & Wellness"
    case photography = "Photography & Digital Arts"
    case travelAdventure = "Travel & Adventure"
    case gardening = "Gardening & Horticulture"
    case astronomy = "Astronomy & Space Exploration"
    case movieCritique = "Movie Critique & Cinematography"
    case literature = "Literature & Creative Writing"
    case entrepreneurship = "Entrepreneurship & Business"
    case fashionDesign = "Fashion & Design"
    case mentalHealth = "Mental Health & Psychology"
    case sports = "Sports & Outdoor Activities"
    case boardGames = "Board Games & Puzzles"
    case classicalMusic = "Classical Music & Opera"
}



class UserInterestViewModel: ObservableObject {
    @Published var selectedInterests: Set<Interest> = []
    
    func toggleInterest(_ interest: Interest) {
        if selectedInterests.contains(interest) {
            selectedInterests.remove(interest)
        } else {
            selectedInterests.insert(interest)
        }
    }
}
