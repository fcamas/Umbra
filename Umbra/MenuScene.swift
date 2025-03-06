//
//  MenuScene.swift
//  Umbra
//
//  Created by Fredy C on 12/26/24.
//

import SpriteKit

class MenuScene: SKScene {
    
    var bgMusic: SKAudioNode!
    
    
    override func didMove(to view: SKView) {
        playBackgroundMusic()
        addBackground()
        addLogo()
        addTitle()
        addStartButton()
        addVersionLabel()
    }
    
    

    func playBackgroundMusic() {
       // bgMusic = SKAudioNode(fileNamed: "bgm.mp3")
       // bgMusic.autoplayLooped = true
        
        
        //addChild(bgMusic)
    }
    func addBackground() {
        let bg = SKSpriteNode(imageNamed: "cave_bg")
        bg.size = CGSize(width: size.width, height: size.height)
        bg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        bg.zPosition = -1
        bg.color = UIColor(red: 0.1, green: 0.0, blue: 0.2, alpha: 1.0)
        bg.colorBlendFactor = 0.5
        addChild(bg)
        
        // Dark overlay for readability
        let overlay = SKShapeNode(rectOf: CGSize(width: size.width, height: size.height))
        overlay.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        overlay.strokeColor = .clear
        overlay.position = CGPoint(x: size.width / 2, y: size.height / 2)
        overlay.zPosition = 0
        addChild(overlay)
    }
    
    func addLogo() {
        let logo = SKSpriteNode(imageNamed: "AppIcon")
        logo.position = CGPoint(x: size.width / 2, y: size.height / 2 + 30)
        logo.size = CGSize(width: 70, height: 70)
        logo.zPosition = 10
        
        // Gentle float
        let up = SKAction.moveBy(x: 0, y: 6, duration: 1.2)
        let down = SKAction.moveBy(x: 0, y: -6, duration: 1.2)
        up.timingMode = .easeInEaseOut
        down.timingMode = .easeInEaseOut
        logo.run(SKAction.repeatForever(SKAction.sequence([up, down])))
        addChild(logo)
    }
    
    func addTitle() {
        let title = SKLabelNode(text: "UMBRA")
    
        title.fontColor = .white
        title.fontName = "AvenirNext-Bold"
        title.position = CGPoint(x: size.width / 2, y: size.height / 2 - 10)
        title.fontSize = 44

     
        title.zPosition = 10
        
        let pulse = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.7, duration: 1.0),
            SKAction.fadeAlpha(to: 1.0, duration: 1.0)
        ])
        title.run(SKAction.repeatForever(pulse))
        addChild(title)
        
        let sub = SKLabelNode(text: "shadow of the demon cat")
        sub.fontSize = 13
        sub.fontColor = UIColor(red: 0.6, green: 0.5, blue: 0.8, alpha: 1.0)
        sub.fontName = "AvenirNext-Regular"
        sub.position = CGPoint(x: size.width / 2, y: size.height / 2 - 30)
        sub.zPosition = 10
        addChild(sub)
    }
    
    func addStartButton() {
        let btn = SKShapeNode(rectOf: CGSize(width: 200, height: 48), cornerRadius: 24)
        btn.fillColor = UIColor(red: 0.3, green: 0.1, blue: 0.5, alpha: 0.9)
        btn.strokeColor = UIColor(red: 0.7, green: 0.3, blue: 1.0, alpha: 1.0)
        btn.lineWidth = 2
        btn.position = CGPoint(x: size.width / 2, y: size.height / 2 - 68)
        btn.name = "startBtn"
        btn.zPosition = 10
        
        let label = SKLabelNode(text: "START GAME")
        label.fontSize = 17
        label.fontColor = UIColor(red: 0.9, green: 0.7, blue: 1.0, alpha: 1.0)
        label.fontName = "AvenirNext-Bold"
        label.verticalAlignmentMode = .center
        label.name = "startBtn"
        btn.addChild(label)
        addChild(btn)
        
        // Pulse border
        let pulse = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.6, duration: 0.8),
            SKAction.fadeAlpha(to: 1.0, duration: 0.8)
        ])
        btn.run(SKAction.repeatForever(pulse))
    }
    
    func addVersionLabel() {
        let version = SKLabelNode(text: "v0.1 demo")
        version.fontSize = 10
        version.fontColor = UIColor(red: 0.4, green: 0.3, blue: 0.5, alpha: 1.0)
        version.position = CGPoint(x: size.width / 2, y: 20)
        version.zPosition = 10
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
