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

    @EnvironmentObject var userSessionViewModel: UserSessionViewModel
    
    var body: some View {
        VStack {
            List(Interest.allCases, id: \.self) { interest in
                HStack {
                    FontText(text: interest.rawValue)
                    Spacer()
                    if viewModel.selectedInterests.contains(interest) {
                        Image(systemName: "checkmark")
                    }
                }
                .onTapGesture {
                    viewModel.toggleInterest(interest)
                }
            }
            
            Button("Let's Go") {
                userSessionViewModel.userDidSelectInterests()
                navigateToFeed = true
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
        }
//        .navigationTitle("Select Interests")
//        .background(NavigationLink("", isActive: $navigateToFeed) {
//            FeedView()
//        })
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Select Interests")
                    .font(.custom("Bitter-Bold", size: 36))
            }
        }
    }
}

