//
//  Story.swift
//  learnai
//
//  Created by Aidan Witeck on 11/11/23.
//

import Foundation

struct Story: Identifiable {
    let id: String
    let title: String
    let content: String
    let followUpQuestion: String
    let categories: [String?]?

    // Initialize with unique ID
    init(title: String, content: String, followUpQuestion: String, categories: [String?]?) {
        self.id = UUID().uuidString
        self.title = title
        self.content = content
        self.followUpQuestion = followUpQuestion
        self.categories = categories
    }
}
