//
//  Story.swift
//  learnai
//
//  Created by Aidan Witeck on 11/11/23.
//

import Foundation

struct Story : Codable, Identifiable {
    let id: String
    let title: String
    let content: String
    let follow_up : String
    let categories: [String?]?
}
