//
//  InterestSelectionView.swift
//  learnai
//
//  Created by Aidan Witeck on 11/10/23.
//

import Foundation
import SwiftUI

struct InterestSelectionView: View {
    @ObservedObject var viewModel: UserInterestViewModel
    @State private var navigateToFeed = false

    var body: some View {
        VStack {
            List(Interest.allCases, id: \.self) { interest in
                // Existing list code
            }

            Button("Let's Go") {
                navigateToFeed = true
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
        }
        .navigationTitle("Select Interests")
        .background(NavigationLink("", isActive: $navigateToFeed) {
            FeedView()
        })
    }
}

