//
//  UserSessionViewModel.swift
//  learnai
//
//  Created by Aidan Witeck on 11/10/23.
//

import Foundation
import SwiftUI

class UserSessionViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var hasSelectedPreferences: Bool = false

    // Call this method when the user successfully signs up
    func userDidLogIn() {
        isLoggedIn = true
        hasSelectedPreferences = false // Assuming new users need to select preferences
    }
    
    func userDidSelectInterests() {
        hasSelectedPreferences = true
    }
}
