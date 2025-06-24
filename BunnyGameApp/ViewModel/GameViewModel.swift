//
//  GameViewModel.swift
//  FruitGameApp
//
//  Created by Surya on 19/06/25.
//

import Foundation
import Combine

class GameViewModel: ObservableObject {
    @Published var score: Int = 0

    func increaseScore() {
        score += 1
    }
    
    func decreaseScore() {
        score = max(0, score - 1)
    }

}
