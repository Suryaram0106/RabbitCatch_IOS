//
//  GameView.swift
//  FruitGameApp
//
//  Created by Surya on 19/06/25.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    @StateObject var viewModel = GameViewModel()

    var scene: SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: 400, height: 800)
        scene.scaleMode = .resizeFill
        scene.viewModel = viewModel
        return scene
    }

    var body: some View {
        VStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
            Text("Score: \(viewModel.score)")
                .font(.title)
                .padding()
        }
    }
}

#Preview {
    GameView()
}
