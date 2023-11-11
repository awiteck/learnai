//
//  SignUpView.swift
//  learnai
//
//  Created by Aidan Witeck on 11/11/23.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var navigateToInterestSelection = false
    @State private var isLoading = false
    @EnvironmentObject var userSessionViewModel: UserSessionViewModel

    var body: some View {
        VStack(spacing: 20) {
            FontText(text: "SIGN YO BITCH ASS UP!")
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .keyboardType(.emailAddress)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Sign Up") {
                isLoading = true // Start loading
                signUpUser(email: email, password: password) { success in
                    DispatchQueue.main.async {
                        isLoading = false // Stop loading
                        if success {
                            userSessionViewModel.userDidLogIn()
                        } else {
                            // Handle sign-up failure
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5, anchor: .center)
            }
            
        }
        .disabled(isLoading) // Disable interaction while loading
        .opacity(isLoading ? 0.5 : 1) // Dim the view when loading
        .padding()
        .padding()
        .navigationDestination(isPresented: $navigateToInterestSelection) {
            InterestSelectionView(viewModel: UserInterestViewModel())
        }
    }
    
    func signUpUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Sign up error: \(error.localizedDescription)")
                completion(false)
                return
            }
            // Check authResult for further customization if needed
            completion(true)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

