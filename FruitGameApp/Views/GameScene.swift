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
    private var character: SKSpriteNode!
    private var catchSound: SKAction!
    private var screenWidth: CGFloat!
    
    private var balloonHitCount = 0
    private var isGameOver = false

    
    struct PhysicsCategory {
        static let character: UInt32 = 0x1 << 0
        static let fruit: UInt32 = 0x1 << 1
        static let balloon: UInt32 = 0x1 << 2
    }

    func spawnBalloon() {
        let balloon = SKSpriteNode(imageNamed: "balloon")
        let x = CGFloat.random(in: 50...screenWidth - 50)
        balloon.position = CGPoint(x: x, y: size.height + 50)
        balloon.physicsBody = SKPhysicsBody(circleOfRadius: balloon.size.width / 2)
        balloon.physicsBody?.categoryBitMask = PhysicsCategory.balloon
        balloon.physicsBody?.contactTestBitMask = PhysicsCategory.character
        balloon.physicsBody?.collisionBitMask = 0
        balloon.physicsBody?.isDynamic = true
        balloon.physicsBody?.affectedByGravity = true
        addChild(balloon)
    }

    func spawnFruitsContinuously() {
        removeAction(forKey: "fruitSpawner")

        let fruitSpawn = SKAction.run { self.spawnFruit() }
        let balloonSpawn = SKAction.run { self.spawnBalloon() }

        let wait = SKAction.wait(forDuration: 4.5)

        let randomSpawner = SKAction.run {
            if Bool.random() {
                self.spawnFruit()
            } else {
                self.spawnBalloon()
            }
        }

        let sequence = SKAction.sequence([wait, randomSpawner])
        let repeatAction = SKAction.repeatForever(sequence)

        run(repeatAction, withKey: "fruitSpawner")
    }


    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        moveCharacter(to: location.x)
    }


    
    override func didMove(to view: SKView) {
        backgroundColor = .systemTeal
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -1.5) // 🔽 Default is -9.8
        screenWidth = size.width
        catchSound = SKAction.playSoundFileNamed("catch.wav", waitForCompletion: false)
        setupCharacter()
        spawnFruitsContinuously()
    }

    func setupCharacter() {
        character = SKSpriteNode(imageNamed: "character")
        character.position = CGPoint(x: size.width / 2, y: 100)
        character.physicsBody = SKPhysicsBody(rectangleOf: character.size)
        character.physicsBody?.isDynamic = false
        character.physicsBody?.categoryBitMask = PhysicsCategory.character
        character.physicsBody?.contactTestBitMask = PhysicsCategory.fruit
        character.physicsBody?.collisionBitMask = 0
        addChild(character)
    }

    func spawnFruit() {
        let fruit = SKSpriteNode(imageNamed: "fruit")
        let x = CGFloat.random(in: 50...screenWidth - 50)
        fruit.position = CGPoint(x: x, y: size.height + 50)
        fruit.physicsBody = SKPhysicsBody(circleOfRadius: fruit.size.width / 2)
        fruit.physicsBody?.categoryBitMask = PhysicsCategory.fruit
        fruit.physicsBody?.contactTestBitMask = PhysicsCategory.character
        fruit.physicsBody?.collisionBitMask = 0
        fruit.physicsBody?.isDynamic = true
        fruit.physicsBody?.affectedByGravity = true
        addChild(fruit)
    }

    func restartGame() {
        // Clear all nodes
        removeAllChildren()

        // Reset state
        isGameOver = false
        balloonHitCount = 0
        physicsWorld.speed = 1
        viewModel.score = 0

        // Re-setup game
        didMove(to: self.view!)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let nodesAtPoint = nodes(at: location)
        if isGameOver {
            if nodesAtPoint.contains(where: { $0.name == "RestartButton" }) {
                restartGame()
            }
            return
        }

        moveCharacter(to: location.x)
    }
    func moveCharacter(to x: CGFloat) {
        let clampedX = min(max(x, 50), screenWidth - 50)
        let moveAction = SKAction.moveTo(x: clampedX, duration: 0.1)
        character.run(moveAction)
    }



    func showRestartButton() {
        let restartButton = SKLabelNode(text: "🔄 Restart")
        restartButton.name = "RestartButton"
        restartButton.fontName = "AvenirNext-Bold"
        restartButton.fontSize = 36
        restartButton.fontColor = .white
        restartButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 80)
        restartButton.zPosition = 100
        addChild(restartButton)
    }


    
    func didBegin(_ contact: SKPhysicsContact) {
        let categoryA = contact.bodyA.categoryBitMask
        let categoryB = contact.bodyB.categoryBitMask

        if categoryA == PhysicsCategory.fruit || categoryB == PhysicsCategory.fruit {
            viewModel.increaseScore()
            run(catchSound)

            if categoryA == PhysicsCategory.fruit {
                contact.bodyA.node?.removeFromParent()
            } else {
                contact.bodyB.node?.removeFromParent()
            }

        }
//        else if categoryA == PhysicsCategory.balloon || categoryB == PhysicsCategory.balloon {
//            viewModel.decreaseScore() // 🆕 (create this in ViewModel)
//            run(catchSound)
//
//            if categoryA == PhysicsCategory.balloon {
//                contact.bodyA.node?.removeFromParent()
//            } else {
//                contact.bodyB.node?.removeFromParent()
//            }
//        }
        
        else if categoryA == PhysicsCategory.balloon || categoryB == PhysicsCategory.balloon {
            run(catchSound)

            // Remove balloon node
            if categoryA == PhysicsCategory.balloon {
                contact.bodyA.node?.removeFromParent()
            } else {
                contact.bodyB.node?.removeFromParent()
            }

            // Decrease score
            viewModel.decreaseScore()

            // Increase balloon hit count
            balloonHitCount += 1

            if balloonHitCount >= 3 {
                triggerGameOver()
            }
        }

        
        func triggerGameOver() {
            isGameOver = true
            removeAllActions()
            physicsWorld.speed = 0

            // Game Over Text
            let label = SKLabelNode(text: "Game Over")
            label.fontName = "AvenirNext-Bold"
            label.fontSize = 50
            label.fontColor = .red
            label.position = CGPoint(x: size.width / 2, y: size.height / 2 + 40)
            label.zPosition = 100
            addChild(label)

            // Sad Emoji Animation 🥺
            let emoji = SKLabelNode(text: "😢")
            emoji.fontSize = 60
            emoji.position = CGPoint(x: size.width / 2, y: size.height / 2 + 100)
            emoji.zPosition = 101
            addChild(emoji)

            let bounce = SKAction.sequence([
                SKAction.moveBy(x: 0, y: 10, duration: 0.3),
                SKAction.moveBy(x: 0, y: -10, duration: 0.3)
            ])
            emoji.run(SKAction.repeatForever(bounce))

            // Show Restart Button
            showRestartButton()
        }

        
 

    }

}
