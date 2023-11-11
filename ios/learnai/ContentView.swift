//
//  ContentView.swift
//  learnai
//
//  Created by Aidan Witeck on 11/10/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var userSessionViewModel = UserSessionViewModel()

    var body: some View {
        NavigationView {
            if !userSessionViewModel.isLoggedIn {
//                LoginView() // Replace with your actual login view
                InterestSelectionView(viewModel: UserInterestViewModel())
            } else if !userSessionViewModel.hasSelectedPreferences {
                InterestSelectionView(viewModel: UserInterestViewModel())
            } else {
                FeedView() // Replace with your actual infinite scrolling view
            }
        }
    }
}
