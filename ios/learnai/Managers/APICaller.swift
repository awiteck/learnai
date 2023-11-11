//
//  APICaller.swift
//  learnai
//
//  Created by Aidan Witeck on 11/11/23.
//

import Foundation
import SwiftUI
import FirebaseAuth

final class APICaller {
    static let shared = APICaller()
    
    private init() {}
    
    struct Constants {
        static let baseAPIURL = "http://learn-ai-working-env.eba-3q49xgtu.us-east-2.elasticbeanstalk.com/"
    }
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    public func createUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            print("CREATED USER 1")
            if let error = error {
                print("There was an error: \(error.localizedDescription)")
                completion(false)
            } else {
                print("CREATED USER 2")
                guard let user = authResult?.user else {
                    completion(false)
                    return
                }
                print("CREATED USER 3")
                print("User created successfully in Firebase. User info: \(String(describing: authResult))")
                let parameters: [String: Any] = [
                    "firebase_uid": String(user.uid),
                    "email": "example@example.com"
                ]
                guard let url = URL(string: Constants.baseAPIURL + "register") else {
                    print("Invalid URL")
                    completion(false)
                    return
                }
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                } catch {
                    print("Error: cannot create JSON from parameters")
                    completion(false)
                    return
                }
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    print("CREATED USER 4: DATA TASK")
                    guard let data = data, error == nil else {
                        print("Error: \(error?.localizedDescription ?? "Unknown error")")
                        completion(false)
                        return
                    }
                    print("CREATED USER 5: DATA TASK")
                    
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                        // Process successful response
                        print("Success: \(String(data: data, encoding: .utf8) ?? "")")
                        completion(true)
                    } else {
                        // Handle server-side error
                        print("Server error")
                        completion(false)
                    }
                }.resume()
                
            }
            
        }
        
        
        
        
        
    }
    
    public func updateTopics(topics: [String], completion: @escaping (Bool) -> Void) {
        return
    }
    
    public func getFacts(userlimit:Int=5, completion: @escaping (Result<[Story], Error>) -> Void) {
        return
    }
    
    public func viewFact(factId: String, completion: @escaping (Bool) -> Void) {
        return
    }
    
    public func upvoteFact(factId: String, completion: @escaping (Bool) -> Void) {
        return
    }
    public func downvoteFact(factId: String, completion: @escaping (Bool) -> Void) {
        return
    }
    
    
    
    //        private func createRequest(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void) {
    //            AuthManager.shared.withValidToken { token in
    //                guard let apiURL = url else {
    //                    return
    //                }
    //                var request = URLRequest(url: apiURL)
    //                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    //                request.httpMethod = type.rawValue
    //                request.timeoutInterval = 30
    //                completion(request)
    //            }
    //        }
    
}
