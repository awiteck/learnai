//
//  MainView.swift
//  learnai
//
//  Created by Aidan Witeck on 11/10/23.
//

import Foundation
import SwiftUI

struct MainView: View {
    @StateObject var userInterestViewModel = UserInterestViewModel()

    var body: some View {
        NavigationView {
            InterestSelectionView(viewModel: userInterestViewModel)
        }
    }
}
