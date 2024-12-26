//
//  MenuScene.swift
//  Umbra
//
//  Created by Fredy C on 12/26/24.
//


import SpriteKit

class MenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        addTitle()
        addStartButton()
        addSubtitle()
    }
    
    func addTitle() {
        let title = SKLabelNode(text: "UMBRA")
        title.fontSize = 64
        title.fontColor = .white
        title.fontName = "AvenirNext-Bold"
        title.position = CGPoint(x: size.width / 2, y: size.height / 2 + 80)
        title.zPosition = 10
        
        // Pulse animation
        let pulse = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.6, duration: 0.8),
            SKAction.fadeAlpha(to: 1.0, duration: 0.8)
        ])
        title.run(SKAction.repeatForever(pulse))
        addChild(title)
        
        // Subtitle
        let sub = SKLabelNode(text: "shadow of the demon cat")
        sub.fontSize = 16
        sub.fontColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        sub.fontName = "AvenirNext-Regular"
        sub.position = CGPoint(x: size.width / 2, y: size.height / 2 + 40)
        addChild(sub)
    }
    
    func addStartButton() {
        let btn = SKShapeNode(rectOf: CGSize(width: 180, height: 50), cornerRadius: 12)
        btn.fillColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        btn.strokeColor = UIColor(red: 0.4, green: 0.8, blue: 1.0, alpha: 1.0)
        btn.lineWidth = 1.5
        btn.position = CGPoint(x: size.width / 2, y: size.height / 2 - 40)
        btn.name = "startBtn"
        btn.zPosition = 10
        
        let label = SKLabelNode(text: "START GAME")
        label.fontSize = 18
        label.fontColor = UIColor(red: 0.4, green: 0.8, blue: 1.0, alpha: 1.0)
        label.fontName = "AvenirNext-Bold"
        label.verticalAlignmentMode = .center
        label.name = "startBtn"
        btn.addChild(label)
        addChild(btn)
    }
    
    func addSubtitle() {
        let version = SKLabelNode(text: "v0.1 demo")
        version.fontSize = 11
        version.fontColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        version.position = CGPoint(x: size.width / 2, y: 30)
        addChild(version)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node = atPoint(location)
            let name = node.name ?? node.parent?.name ?? ""
            if name == "startBtn" {
                let game = GameScene(size: size)
                game.scaleMode = scaleMode
                let transition = SKTransition.fade(withDuration: 0.8)
                view?.presentScene(game, transition: transition)
            }
        }
    }
}
