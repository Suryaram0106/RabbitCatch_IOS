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
    @Published var isGameOver: Bool = false

    func reset() {
        score = 0
        isGameOver = false
    }

    func increaseScore(by points: Int = 1) {
        score += points
    }

    func decreaseScore(by points: Int = 1) {
        score = max(0, score - points)
    }
}

