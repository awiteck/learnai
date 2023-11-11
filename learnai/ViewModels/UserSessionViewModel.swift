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

    // Methods to handle login, logout, and preference setting
}
