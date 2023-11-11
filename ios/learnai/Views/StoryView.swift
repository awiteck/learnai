//
//  StoryView.swift
//  learnai
//
//  Created by Aidan Witeck on 11/10/23.
//

import Foundation
import SwiftUI

struct StoryView: View {
    let story: Story

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(story.title)
                .font(.headline)
            FontText(text:story.content, size:18)
//                .font(.body)
            
            HStack {
                Button("Like") {
                    // Implement like action
                }
                Button("Dislike") {
                    // Implement dislike action
                }
            }

            Text(story.followUpQuestion)
                .font(.subheadline)
            
//            ForEach(story.followUpQuestion, id: \.self) { question in
//                Text(question)
//                    .font(.subheadline)
//            }
        }
        .padding()
    }
}

