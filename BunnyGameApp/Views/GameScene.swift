//
//  GameScene.swift
//  FruitGameApp
//
//  Created by Surya on 19/06/25.
//

import SpriteKit
import AVFoundation


class GameScene: SKScene, SKPhysicsContactDelegate {
    var viewModel: GameViewModel!
    var gameOverHandler: (() -> Void)?

    private var character: SKSpriteNode!
    private var screenWidth: CGFloat!
    private var balloonHitCount = 0

    struct PhysicsCategory {
        static let character: UInt32 = 0x1 << 0
        static let fruit: UInt32 = 0x1 << 1
        static let balloon: UInt32 = 0x1 << 2
        static let specialItem: UInt32 = 0x1 << 3
    }

    override func didMove(to view: SKView) {
        backgroundColor = .systemTeal
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -1.5)

        screenWidth = size.width
        setupCharacter()
        spawnItemsContinuously()
    }

    func setupCharacter() {
        character = SKSpriteNode(imageNamed: "character")
        character.position = CGPoint(x: size.width / 2, y: 100)
        character.physicsBody = SKPhysicsBody(rectangleOf: character.size)
        character.physicsBody?.isDynamic = false
        character.physicsBody?.categoryBitMask = PhysicsCategory.character
        character.physicsBody?.contactTestBitMask = PhysicsCategory.fruit | PhysicsCategory.balloon | PhysicsCategory.specialItem
        character.physicsBody?.collisionBitMask = 0
        addChild(character)
    }

    func spawnItemsContinuously() {
        let waitDuration = SKAction.wait(forDuration: max(0.5, 1.5 - (Double(viewModel.score) / 20.0)))
        let spawn = SKAction.run { [weak self] in
            guard let self = self else { return }
            let rand = Int.random(in: 0...100)
            if rand < 60 {
                self.spawnFruit()
            } else if rand < 90 {
                self.spawnBalloon()
            } else {
                self.spawnSpecialItem()
            }
        }
        let sequence = SKAction.sequence([waitDuration, spawn])
        run(SKAction.repeatForever(sequence))
    }

    func spawnFruit() {
        let fruit = SKSpriteNode(imageNamed: "fruit")
        fruit.position = CGPoint(x: CGFloat.random(in: 50...screenWidth-50), y: size.height + 50)
        fruit.physicsBody = SKPhysicsBody(circleOfRadius: fruit.size.width / 2)
        fruit.physicsBody?.categoryBitMask = PhysicsCategory.fruit
        fruit.physicsBody?.contactTestBitMask = PhysicsCategory.character
        fruit.physicsBody?.collisionBitMask = 0
        fruit.physicsBody?.affectedByGravity = true
        addChild(fruit)
    }

    func spawnBalloon() {
        let balloon = SKSpriteNode(imageNamed: "balloon")
        balloon.position = CGPoint(x: CGFloat.random(in: 50...screenWidth-50), y: size.height + 50)
        balloon.physicsBody = SKPhysicsBody(circleOfRadius: balloon.size.width / 2)
        balloon.physicsBody?.categoryBitMask = PhysicsCategory.balloon
        balloon.physicsBody?.contactTestBitMask = PhysicsCategory.character
        balloon.physicsBody?.collisionBitMask = 0
        balloon.physicsBody?.affectedByGravity = true
        addChild(balloon)
    }

    func spawnSpecialItem() {
        let star = SKSpriteNode(imageNamed: "star") // Add this image
        star.position = CGPoint(x: CGFloat.random(in: 50...screenWidth-50), y: size.height + 50)
        star.physicsBody = SKPhysicsBody(circleOfRadius: star.size.width / 2)
        star.physicsBody?.categoryBitMask = PhysicsCategory.specialItem
        star.physicsBody?.contactTestBitMask = PhysicsCategory.character
        star.physicsBody?.collisionBitMask = 0
        star.physicsBody?.affectedByGravity = true
        addChild(star)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        moveCharacter(to: location.x)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        moveCharacter(to: location.x)
    }

    func moveCharacter(to x: CGFloat) {
        let clampedX = min(max(x, 50), screenWidth - 50)
        character.position.x = clampedX
    }

    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node

        let categoryA = contact.bodyA.categoryBitMask
        let categoryB = contact.bodyB.categoryBitMask
        let combinedCategory = categoryA | categoryB

        if combinedCategory == PhysicsCategory.character | PhysicsCategory.fruit {
            viewModel.increaseScore()
            // Remove only the fruit
            if categoryA == PhysicsCategory.fruit {
                nodeA?.removeFromParent()
            } else if categoryB == PhysicsCategory.fruit {
                nodeB?.removeFromParent()
            }
        } else if combinedCategory == PhysicsCategory.character | PhysicsCategory.balloon {
            balloonHitCount += 1
            viewModel.decreaseScore()
            // Remove only the balloon
            if categoryA == PhysicsCategory.balloon {
                nodeA?.removeFromParent()
            } else if categoryB == PhysicsCategory.balloon {
                nodeB?.removeFromParent()
            }

            if balloonHitCount >= 3 {
                endGame()
            }
        } else if combinedCategory == PhysicsCategory.character | PhysicsCategory.specialItem {
            viewModel.increaseScore(by: 5)
            // Remove only the special item
            if categoryA == PhysicsCategory.specialItem {
                nodeA?.removeFromParent()
            } else if categoryB == PhysicsCategory.specialItem {
                nodeB?.removeFromParent()
            }
        }
    }


    func endGame() {
        removeAllActions()
        physicsWorld.speed = 0
        gameOverHandler?()
    }
    
}


    
//    func didBegin(_ contact: SKPhysicsContact) {
//        let categories = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
//
//        if categories == PhysicsCategory.character | PhysicsCategory.fruit {
//            viewModel.increaseScore()
//            (contact.bodyA.node ?? contact.bodyB.node)?.removeFromParent()
//        }
//        else if categories == PhysicsCategory.character | PhysicsCategory.balloon {
//            balloonHitCount += 1
//            (contact.bodyA.node ?? contact.bodyB.node)?.removeFromParent()
//            viewModel.decreaseScore()
//
//            if balloonHitCount >= 3 {
//                gameOverHandler?()
//            }
//        }
//    }



//class GameScene: SKScene, SKPhysicsContactDelegate {
//    var viewModel: GameViewModel!
//    private var character: SKSpriteNode!
//    private var catchSound: SKAction!
//    private var screenWidth: CGFloat!
//    
//    private var balloonHitCount = 0
//    private var isGameOver = false
//
//    
//    struct PhysicsCategory {
//        static let character: UInt32 = 0x1 << 0
//        static let fruit: UInt32 = 0x1 << 1
//        static let balloon: UInt32 = 0x1 << 2
//        static let star: UInt32 = 0x1 << 3
//           static let bomb: UInt32 = 0x1 << 4
//    }
//
//    func spawnBalloon() {
//        let balloon = SKSpriteNode(imageNamed: "balloon")
//        let x = CGFloat.random(in: 50...screenWidth - 50)
//        balloon.position = CGPoint(x: x, y: size.height + 50)
//        balloon.physicsBody = SKPhysicsBody(circleOfRadius: balloon.size.width / 2)
//        balloon.physicsBody?.categoryBitMask = PhysicsCategory.balloon
//        balloon.physicsBody?.contactTestBitMask = PhysicsCategory.character
//        balloon.physicsBody?.collisionBitMask = 0
//        balloon.physicsBody?.isDynamic = true
//        balloon.physicsBody?.affectedByGravity = true
//        addChild(balloon)
//    }
//
//    
//    func spawnStar() {
//        let star = SKSpriteNode(imageNamed: "star")
//        let x = CGFloat.random(in: 50...screenWidth-50)
//        star.position = CGPoint(x: x, y: size.height + 50)
//        star.physicsBody = SKPhysicsBody(circleOfRadius: star.size.width / 2)
//        star.physicsBody?.categoryBitMask = PhysicsCategory.star
//        star.physicsBody?.contactTestBitMask = PhysicsCategory.character
//        star.physicsBody?.collisionBitMask = 0
//        star.physicsBody?.isDynamic = true
//        star.physicsBody?.affectedByGravity = true
//        addChild(star)
//    }
//
//    func spawnBomb() {
//        let bomb = SKSpriteNode(imageNamed: "bomb")
//        let x = CGFloat.random(in: 50...screenWidth-50)
//        bomb.position = CGPoint(x: x, y: size.height + 50)
//        bomb.physicsBody = SKPhysicsBody(circleOfRadius: bomb.size.width / 2)
//        bomb.physicsBody?.categoryBitMask = PhysicsCategory.bomb
//        bomb.physicsBody?.contactTestBitMask = PhysicsCategory.character
//        bomb.physicsBody?.collisionBitMask = 0
//        bomb.physicsBody?.isDynamic = true
//        bomb.physicsBody?.affectedByGravity = true
//        addChild(bomb)
//    }
//
//    
//    func spawnFruitsContinuously() {
//        removeAction(forKey: "fruitSpawner")
//
//        let fruitSpawn = SKAction.run { self.spawnFruit() }
//        let balloonSpawn = SKAction.run { self.spawnBalloon() }
//
//        let wait = SKAction.wait(forDuration: 4.5)
//
//        let randomSpawner = SKAction.run {
//            let chance = Int.random(in: 1...100)
//
//            if chance <= 60 {
//                self.spawnFruit()
//            } else if chance <= 80 {
//                self.spawnStar()
//            } else if chance <= 100 {
//                self.spawnBomb()
//            }
//        }
//
//
//        let sequence = SKAction.sequence([wait, randomSpawner])
//        let repeatAction = SKAction.repeatForever(sequence)
//
//        run(repeatAction, withKey: "fruitSpawner")
//    }
//
//
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        let location = touch.location(in: self)
//        moveCharacter(to: location.x)
//    }
//
//
//    
//    override func didMove(to view: SKView) {
//        backgroundColor = .systemTeal
//        physicsWorld.contactDelegate = self
//        physicsWorld.gravity = CGVector(dx: 0, dy: -1.5) // 🔽 Default is -9.8
//        screenWidth = size.width
//        catchSound = SKAction.playSoundFileNamed("catch.wav", waitForCompletion: false)
//        setupCharacter()
//        spawnFruitsContinuously()
//    }
//
//    func setupCharacter() {
//        character = SKSpriteNode(imageNamed: "character")
//        character.position = CGPoint(x: size.width / 2, y: 100)
//        character.physicsBody = SKPhysicsBody(rectangleOf: character.size)
//        character.physicsBody?.isDynamic = false
//        character.physicsBody?.categoryBitMask = PhysicsCategory.character
//        character.physicsBody?.contactTestBitMask = PhysicsCategory.fruit
//        character.physicsBody?.collisionBitMask = 0
//        addChild(character)
//    }
//
//    func spawnFruit() {
//        let fruit = SKSpriteNode(imageNamed: "fruit")
//        let x = CGFloat.random(in: 50...screenWidth - 50)
//        fruit.position = CGPoint(x: x, y: size.height + 50)
//        fruit.physicsBody = SKPhysicsBody(circleOfRadius: fruit.size.width / 2)
//        fruit.physicsBody?.categoryBitMask = PhysicsCategory.fruit
//        fruit.physicsBody?.contactTestBitMask = PhysicsCategory.character
//        fruit.physicsBody?.collisionBitMask = 0
//        fruit.physicsBody?.isDynamic = true
//        fruit.physicsBody?.affectedByGravity = true
//        addChild(fruit)
//    }
//
//    func restartGame() {
//        // Clear all nodes
//        removeAllChildren()
//
//        // Reset state
//        isGameOver = false
//        balloonHitCount = 0
//        physicsWorld.speed = 1
//        viewModel.score = 0
//
//        // Re-setup game
//        didMove(to: self.view!)
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        let location = touch.location(in: self)
//        
//        let nodesAtPoint = nodes(at: location)
//        if isGameOver {
//            if nodesAtPoint.contains(where: { $0.name == "RestartButton" }) {
//                restartGame()
//            }
//            return
//        }
//
//        moveCharacter(to: location.x)
//    }
//    func moveCharacter(to x: CGFloat) {
//        let clampedX = min(max(x, 50), screenWidth - 50)
//        let moveAction = SKAction.moveTo(x: clampedX, duration: 0.1)
//        character.run(moveAction)
//    }
//
//
//
//    func showRestartButton() {
//        let restartButton = SKLabelNode(text: "🔄 Restart")
//        restartButton.name = "RestartButton"
//        restartButton.fontName = "AvenirNext-Bold"
//        restartButton.fontSize = 36
//        restartButton.fontColor = .white
//        restartButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 80)
//        restartButton.zPosition = 100
//        addChild(restartButton)
//    }
//
//
//    
//    func didBegin(_ contact: SKPhysicsContact) {
//        let categoryA = contact.bodyA.categoryBitMask
//        let categoryB = contact.bodyB.categoryBitMask
//
//        if categoryA == PhysicsCategory.fruit || categoryB == PhysicsCategory.fruit {
//            viewModel.increaseScore()
//            run(catchSound)
//
//            if categoryA == PhysicsCategory.fruit {
//                contact.bodyA.node?.removeFromParent()
//            } else {
//                contact.bodyB.node?.removeFromParent()
//            }
//
//        }
////        else if categoryA == PhysicsCategory.balloon || categoryB == PhysicsCategory.balloon {
////            viewModel.decreaseScore() // 🆕 (create this in ViewModel)
////            run(catchSound)
////
////            if categoryA == PhysicsCategory.balloon {
////                contact.bodyA.node?.removeFromParent()
////            } else {
////                contact.bodyB.node?.removeFromParent()
////            }
////        }
//        
//        else if categoryA == PhysicsCategory.balloon || categoryB == PhysicsCategory.balloon {
//            run(catchSound)
//
//            // Remove balloon node
//            if categoryA == PhysicsCategory.balloon {
//                contact.bodyA.node?.removeFromParent()
//            } else {
//                contact.bodyB.node?.removeFromParent()
//            }
//
//            // Decrease score
//            viewModel.decreaseScore()
//
//            // Increase balloon hit count
//            balloonHitCount += 1
//
//            if balloonHitCount >= 3 {
//                triggerGameOver()
//            }
//        }
//
//        
//        func triggerGameOver() {
//            isGameOver = true
//            removeAllActions()
//            physicsWorld.speed = 0
//
//            // Game Over Text
//            let label = SKLabelNode(text: "Game Over")
//            label.fontName = "AvenirNext-Bold"
//            label.fontSize = 50
//            label.fontColor = .red
//            label.position = CGPoint(x: size.width / 2, y: size.height / 2 + 40)
//            label.zPosition = 100
//            addChild(label)
//
//            // Sad Emoji Animation 🥺
//            let emoji = SKLabelNode(text: "😢")
//            emoji.fontSize = 60
//            emoji.position = CGPoint(x: size.width / 2, y: size.height / 2 + 100)
//            emoji.zPosition = 101
//            addChild(emoji)
//
//            let bounce = SKAction.sequence([
//                SKAction.moveBy(x: 0, y: 10, duration: 0.3),
//                SKAction.moveBy(x: 0, y: -10, duration: 0.3)
//            ])
//            emoji.run(SKAction.repeatForever(bounce))
//
//            // Show Restart Button
//            showRestartButton()
//        }
//
//        
// 
//
//    }
//
//}
