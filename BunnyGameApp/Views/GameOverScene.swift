//
//  GameOverScene.swift
//  BunnyGame
//
//  Created by Surya on 24/06/25.
//

import SpriteKit

//class GameOverScene: SKScene {
//    var finalScore: Int = 0
//    var restartHandler: (() -> Void)?
//
//    override init(size: CGSize) {
//          super.init(size: size)
//          self.backgroundColor = .systemTeal
//          self.scaleMode = .aspectFill // or .resizeFill
//      }
//    
//    
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func didMove(to view: SKView) {
//        //backgroundColor = .black
//       // backgroundColor = .systemTeal
//
//        let gameOverLabel = SKLabelNode(text: "Game Over")
//        gameOverLabel.fontName = "AvenirNext-Bold"
//        gameOverLabel.fontSize = 50
//        gameOverLabel.fontColor = .red
//        gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + 40)
//        addChild(gameOverLabel)
//
//        let scoreLabel = SKLabelNode(text: "Final Score: \(finalScore)")
//        scoreLabel.fontName = "AvenirNext-Regular"
//        scoreLabel.fontSize = 30
//        scoreLabel.fontColor = .white
//        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
//        addChild(scoreLabel)
//
//        let restartLabel = SKLabelNode(text: "Tap to Restart")
//        restartLabel.fontName = "AvenirNext-Regular"
//        restartLabel.fontSize = 24
//        restartLabel.fontColor = .white
//        restartLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 - 50)
//        addChild(restartLabel)
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        restartHandler?()
//    }
//}

import SpriteKit

class GameOverScene: SKScene {
    var finalScore: Int = 0
    var restartHandler: (() -> Void)?

    override init(size: CGSize) {
        super.init(size: size)
        self.scaleMode = .aspectFill
        self.backgroundColor = .systemTeal  // Teal background
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    override func didMove(to view: SKView) {
        // Setup labels
        let gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.fontName = "AvenirNext-Bold"
        gameOverLabel.fontSize = 50
        gameOverLabel.fontColor = .red
        gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + 40)
        addChild(gameOverLabel)

        let scoreLabel = SKLabelNode(text: "Final Score: \(finalScore)")
        scoreLabel.fontName = "AvenirNext-Regular"
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(scoreLabel)

        let restartLabel = SKLabelNode(text: "Tap to Restart")
        restartLabel.fontName = "AvenirNext-Regular"
        restartLabel.fontSize = 24
        restartLabel.fontColor = .white
        restartLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 - 50)
        addChild(restartLabel)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        restartHandler?()
    }
}
