//
//  GameView.swift
//  FruitGameApp
//
//  Created by Surya on 19/06/25.
//

import SwiftUI
import SpriteKit


//struct GameView: View {
//    @StateObject var viewModel = GameViewModel()
//    @State private var currentScene: SKScene?
//
//    private func makeGameScene(from skView: SKView) -> GameScene {
//        let scene = GameScene()
//        scene.size = CGSize(width: 400, height: 800)
//        scene.scaleMode = .aspectFill
//        scene.viewModel = viewModel
//        scene.gameOverHandler = {
//            DispatchQueue.main.async {
//                let gameOverScene = GameOverScene(size: scene.size)
//                gameOverScene.finalScore = viewModel.score
//                gameOverScene.goToMenuHandler = {
//                    DispatchQueue.main.async {
//                        self.makeMenuScene(from: skView) // ➡️ Goes back to menu
//                    }
//                }
//                skView.presentScene(gameOverScene, transition: .doorsOpenVertical(withDuration: 1.0))
//            }
//        }
//        return scene
//    }
//
//
//    
//    var scene: GameScene {
//        let scene = GameScene()
//        scene.size = CGSize(width: 400, height: 800)
//        scene.scaleMode = .aspectFill
//        scene.viewModel = viewModel
//        scene.gameOverHandler = {
//            DispatchQueue.main.async {
//                let gameOverScene = GameOverScene(size: scene.size)
//                gameOverScene.finalScore = viewModel.score
//                gameOverScene.restartHandler = {
//                    DispatchQueue.main.async {
//                        // Restart the game
//                        let newGameScene = GameScene()
//                        newGameScene.size = scene.size
//                        newGameScene.scaleMode = .aspectFill
//                        newGameScene.viewModel = viewModel
//                        newGameScene.gameOverHandler = scene.gameOverHandler
//                        
//                        if let skView = scene.view {
//                            skView.presentScene(newGameScene, transition: .fade(withDuration: 0.5))
//                        }
//                    }
//                }
//                
//                if let skView = scene.view {
//                    skView.presentScene(gameOverScene, transition: .doorsOpenVertical(withDuration: 1.0))
//                }
//            }
//        }
//        return scene
//    }
//
//    var body: some View {
//        SpriteView(scene: scene)
//            .background(Color.teal) // Keep this for consistent background
//            .edgesIgnoringSafeArea(.all)
//    }
//}




struct GameView: View {
    @StateObject var viewModel = GameViewModel()

    var body: some View {
        GeometryReader { geometry in
            SpriteView(scene: initialMenuScene(for: geometry.size))
                .background(Color.teal)
                .edgesIgnoringSafeArea(.all)
        }
    }

    private func initialMenuScene(for size: CGSize) -> SKScene {
        let scene = MenuScene(size: size)
        scene.scaleMode = .aspectFill
        scene.gameStartHandler = {
            DispatchQueue.main.async {
                if let skView = scene.view {
                    let gameScene = makeGameScene(from: skView)
                    skView.presentScene(gameScene, transition: .fade(withDuration: 0.5))
                }
            }
        }
        return scene
    }

    private func makeGameScene(from skView: SKView) -> GameScene {
        let scene = GameScene()
        scene.size = CGSize(width: 400, height: 800)
        scene.scaleMode = .aspectFill
        scene.viewModel = viewModel
        scene.gameOverHandler = {
            DispatchQueue.main.async {
                let gameOverScene = GameOverScene(size: scene.size)
                gameOverScene.finalScore = viewModel.score
                gameOverScene.restartHandler = {
                    DispatchQueue.main.async {
                        self.makeMenuScene(from: skView) // Returns to menu
                    }
                }
                skView.presentScene(gameOverScene, transition: .doorsOpenVertical(withDuration: 1.0))
            }
        }
        return scene
    }

    private func makeMenuScene(from skView: SKView) {
        let menuScene = MenuScene(size: skView.frame.size)
        menuScene.scaleMode = .aspectFill
        menuScene.gameStartHandler = {
            DispatchQueue.main.async {
                let newGameScene = self.makeGameScene(from: skView)
                skView.presentScene(newGameScene, transition: .fade(withDuration: 0.5))
            }
        }
  

        skView.presentScene(menuScene, transition:  SKTransition.moveIn(with: .down, duration: 0.5)
)
      

    }
}


//struct GameView: View {
//    @StateObject var viewModel = GameViewModel()
//
//    var scene: SKScene {
//        let scene = GameScene(size: CGSize(width: 400, height: 800))
//        scene.scaleMode = .aspectFill
//        
//        scene.viewModel = viewModel
//        scene.gameOverHandler = {
//            DispatchQueue.main.async {
//                viewModel.isGameOver = true
//            }
//        }
//        return scene
//    }
//
//    var body: some View {
//        ZStack {
//            if viewModel.isGameOver {
//                GameOverView(viewModel: viewModel)
//            } else {
//                SpriteView(scene: scene)
//                    .background(Color.teal)
//                    .ignoresSafeArea()
//                
//                VStack {
//                    Text("Score: \(viewModel.score)")
//                        .font(.title)
//                        .foregroundColor(.white)
//                        .padding()
//                    Spacer()
//                }
//            }
//        }
//    }
//}





