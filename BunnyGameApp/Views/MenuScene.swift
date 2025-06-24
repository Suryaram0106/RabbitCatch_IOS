//
//  MenuScene.swift
//  BunnyGame
//
//  Created by Surya on 24/06/25.
//

import SpriteKit

class MenuScene: SKScene {
    var gameStartHandler: (() -> Void)?

    override func didMove(to view: SKView) {
        backgroundColor = .systemTeal

        let title = SKLabelNode(text: "Catch the Carrot!")
        title.fontName = "AvenirNext-Bold"
        title.fontSize = 40
        title.fontColor = .white
        title.position = CGPoint(x: size.width / 2, y: size.height / 2 + 50)
        addChild(title)

        let startLabel = SKLabelNode(text: "Tap to Start")
        startLabel.fontName = "AvenirNext-Regular"
        startLabel.fontSize = 24
        startLabel.fontColor = .white
        startLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 - 30)
        startLabel.name = "startLabel"
        addChild(startLabel)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameStartHandler?()
    }
}

