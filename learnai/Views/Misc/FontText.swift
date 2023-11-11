//
//  FontText.swift
//  learnai
//
//  Created by Aidan Witeck on 11/10/23.
//

import Foundation
import SwiftUI

struct FontText: View {
    let text: String
    var size: CGFloat = 16 // Default size

    var body: some View {
        Text(text)
            .font(.custom("Bitter-Regular", size: size))
    }
}
