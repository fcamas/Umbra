//
//  Stage3Scene.swift
//  Umbra
//
//  Created by Fredy C on 1/2/25.
//


import SpriteKit

class Stage3Scene: SKScene {
    
    var umbraBody: SKNode!
    var movingLeft = false
    var movingRight = false
    let moveSpeed: CGFloat = 5.0
    var isOnGround = false
    var facingRight = true
    var health: CGFloat = 100
    let maxHealth: CGFloat = 100
    var healthBar: SKShapeNode!
    var invincible = false
    var hasDoubleJump = true
    var jumpsUsed = 0
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
 
        physicsWorld.contactDelegate = self
        
        buildStage3()
        spawnUmbra()
        addButtons()
        addHealthBar()
        addStageLabel()
    }
    
    func buildStage3() {
        let bg = SKSpriteNode(imageNamed: "cave_bg")
        bg.size = CGSize(width: size.width, height: size.height)
        bg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        bg.zPosition = -1
        bg.color = UIColor(red: 0.0, green: 0.1, blue: 0.4, alpha: 1.0)
        bg.colorBlendFactor = 0.5
        addChild(bg)
        
        let platforms: [(x: CGFloat, y: CGFloat, w: CGFloat)] = [
            (size.width / 2, 80, size.width),
            (size.width * 0.15, 160, 150),
            (size.width * 0.85, 160, 150),
            (size.width * 0.35, 230, 160),
            (size.width * 0.65, 230, 160),
            (size.width * 0.5, 290, 180),
        ]
        
        for (index, p) in platforms.enumerated() {
            let plat = SKShapeNode(rectOf: CGSize(width: p.w, height: 14))
            
            if index == 0 {
                plat.fillColor = .clear
                plat.strokeColor = .clear
            } else {
                plat.fillColor = UIColor(red: 0.05, green: 0.1, blue: 0.4, alpha: 0.9)
                plat.strokeColor = UIColor(red: 0.2, green: 0.4, blue: 1.0, alpha: 1.0)
                plat.lineWidth = 1.5
            }
            
            plat.position = CGPoint(x: p.x, y: p.y)
            plat.name = "ground"
            plat.zPosition = 1
            plat.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: p.w, height: 14))
            plat.physicsBody?.isDynamic = false
            plat.physicsBody?.categoryBitMask = 0x1 << 1
            plat.physicsBody?.contactTestBitMask = 0x1 << 0
            plat.physicsBody?.collisionBitMask = 0x1 << 0
            addChild(plat)
        }
        
        let leftWall = SKShapeNode(rectOf: CGSize(width: 14, height: size.height))
        leftWall.fillColor = .clear
        leftWall.strokeColor = .clear
        leftWall.position = CGPoint(x: 7, y: size.height / 2)
        leftWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 14, height: size.height))
        leftWall.physicsBody?.isDynamic = false
        addChild(leftWall)
        
        let rightWall = SKShapeNode(rectOf: CGSize(width: 14, height: size.height))
        rightWall.fillColor = .clear
        rightWall.strokeColor = .clear
        rightWall.position = CGPoint(x: size.width - 7, y: size.height / 2)
        rightWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 14, height: size.height))
        rightWall.physicsBody?.isDynamic = false
        addChild(rightWall)
    }
    
    func spawnUmbra() {
        umbraBody = SKNode()
        umbraBody.position = CGPoint(x: 80, y: 140)
        umbraBody.name = "umbra"
        
        umbraBody.physicsBody = SKPhysicsBody(circleOfRadius: 28)
        umbraBody.physicsBody?.allowsRotation = false
        umbraBody.physicsBody?.categoryBitMask = 0x1 << 0
        umbraBody.physicsBody?.contactTestBitMask = 0x1 << 1 | 0x1 << 3
        umbraBody.physicsBody?.collisionBitMask = 0x1 << 1
        
        let sprite = SKSpriteNode(imageNamed: "umbra")
        sprite.size = CGSize(width: 90, height: 90)
        sprite.name = "umbraSprite"
        umbraBody.addChild(sprite)
        
        let floatUp = SKAction.moveBy(x: 0, y: 4, duration: 1.0)
        let floatDown = SKAction.moveBy(x: 0, y: -4, duration: 1.0)
        floatUp.timingMode = .easeInEaseOut
        floatDown.timingMode = .easeInEaseOut
        sprite.run(SKAction.repeatForever(SKAction.sequence([floatUp, floatDown])))
        
        addChild(umbraBody)
    }
    
    func addHealthBar() {
        let bgBar = SKShapeNode(rectOf: CGSize(width: 154, height: 16), cornerRadius: 4)
        bgBar.fillColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        bgBar.strokeColor = .clear
        bgBar.position = CGPoint(x: 100, y: size.height - 22)
        bgBar.zPosition = 10
        addChild(bgBar)
        
        healthBar = SKShapeNode(rectOf: CGSize(width: 150, height: 12), cornerRadius: 3)
        healthBar.fillColor = UIColor(red: 0.2, green: 0.9, blue: 0.3, alpha: 1.0)
        healthBar.strokeColor = .clear
        healthBar.position = CGPoint(x: 100, y: size.height - 22)
        healthBar.zPosition = 11
        addChild(healthBar)
        
        let hp = SKLabelNode(text: "HP")
        hp.fontSize = 12
        hp.fontColor = .white
        hp.position = CGPoint(x: 22, y: size.height - 28)
        hp.zPosition = 11
        addChild(hp)
    }
    
    func addStageLabel() {
        let label = SKLabelNode(text: "STAGE 3 — FINAL")
        label.fontSize = 22
        label.fontColor = UIColor(red: 0.2, green: 0.4, blue: 1.0, alpha: 1.0)
        label.fontName = "AvenirNext-Bold"
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        label.zPosition = 20
        addChild(label)
        
        let fade = SKAction.fadeOut(withDuration: 2.0)
        let remove = SKAction.removeFromParent()
        label.run(SKAction.sequence([SKAction.wait(forDuration: 1.5), fade, remove]))
    }
    
    func addButtons() {
        let leftBtn = SKShapeNode(rectOf: CGSize(width: 55, height: 55), cornerRadius: 10)
        leftBtn.fillColor = UIColor(white: 0.2, alpha: 0.8)
        leftBtn.strokeColor = .clear
        leftBtn.position = CGPoint(x: 50, y: 50)
        leftBtn.name = "leftBtn"
        leftBtn.zPosition = 10
        let leftLabel = SKLabelNode(text: "<")
        leftLabel.fontSize = 26
        leftLabel.verticalAlignmentMode = .center
        leftBtn.addChild(leftLabel)
        addChild(leftBtn)
        
        let rightBtn = SKShapeNode(rectOf: CGSize(width: 55, height: 55), cornerRadius: 10)
        rightBtn.fillColor = UIColor(white: 0.2, alpha: 0.8)
        rightBtn.strokeColor = .clear
        rightBtn.position = CGPoint(x: 115, y: 50)
        rightBtn.name = "rightBtn"
        rightBtn.zPosition = 10
        let rightLabel = SKLabelNode(text: ">")
        rightLabel.fontSize = 26
        rightLabel.verticalAlignmentMode = .center
        rightBtn.addChild(rightLabel)
        addChild(rightBtn)
        
        let jumpBtn = SKShapeNode(rectOf: CGSize(width: 55, height: 55), cornerRadius: 10)
        jumpBtn.fillColor = UIColor(white: 0.2, alpha: 0.8)
        jumpBtn.strokeColor = .clear
        jumpBtn.position = CGPoint(x: size.width - 50, y: 50)
        jumpBtn.name = "jumpBtn"
        jumpBtn.zPosition = 10
        let jumpLabel = SKLabelNode(text: "^")
        jumpLabel.fontSize = 26
        jumpLabel.verticalAlignmentMode = .center
        jumpBtn.addChild(jumpLabel)
        addChild(jumpBtn)
        
        let attackBtn = SKShapeNode(rectOf: CGSize(width: 55, height: 55), cornerRadius: 10)
        attackBtn.fillColor = UIColor(red: 0.5, green: 0.1, blue: 0.1, alpha: 0.8)
        attackBtn.strokeColor = .clear
        attackBtn.position = CGPoint(x: size.width - 115, y: 50)
        attackBtn.name = "attackBtn"
        attackBtn.zPosition = 10
        let attackLabel = SKLabelNode(text: "X")
        attackLabel.fontSize = 26
        attackLabel.verticalAlignmentMode = .center
        attackBtn.addChild(attackLabel)
        addChild(attackBtn)
    }
    
    func shoot() {
        let ball = SKShapeNode(circleOfRadius: 7)
        ball.fillColor = UIColor(red: 0.2, green: 0.5, blue: 1.0, alpha: 1.0)
        ball.strokeColor = .clear
        ball.position = umbraBody.position
        ball.name = "projectile"
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 7)
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.categoryBitMask = 0x1 << 2
        ball.physicsBody?.contactTestBitMask = 0x1 << 3
        ball.physicsBody?.collisionBitMask = 0
        addChild(ball)
        let direction: CGFloat = facingRight ? 1 : -1
        let move = SKAction.moveBy(x: direction * size.width, y: 0, duration: 0.5)
        let remove = SKAction.removeFromParent()
        ball.run(SKAction.sequence([move, remove]))
    }
    
    func takeDamage() {
        guard !invincible else { return }
        invincible = true
        health -= 20
        if health < 0 { health = 0 }
        let ratio = health / maxHealth
        healthBar.xScale = ratio
        healthBar.position.x = 100 - (150 - 150 * ratio) / 2
        let fadeOut = SKAction.fadeAlpha(to: 0.2, duration: 0.1)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.1)
        let blink = SKAction.repeat(SKAction.sequence([fadeOut, fadeIn]), count: 4)
        let reset = SKAction.run { self.invincible = false }
        umbraBody.run(SKAction.sequence([blink, reset]))
        if health <= 0 { gameOver() }
    }
    
    func gameOver() {
        umbraBody.physicsBody?.isDynamic = false
        let overlay = SKShapeNode(rectOf: CGSize(width: size.width, height: size.height))
        overlay.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        overlay.strokeColor = .clear
        overlay.position = CGPoint(x: size.width / 2, y: size.height / 2)
        overlay.zPosition = 20
        addChild(overlay)
        let label = SKLabelNode(text: "GAME OVER")
        label.fontSize = 44
        label.fontColor = .red
        label.fontName = "AvenirNext-Bold"
        label.position = CGPoint(x: size.width / 2, y: size.height / 2 + 30)
        label.zPosition = 21
        addChild(label)
        let btn = SKShapeNode(rectOf: CGSize(width: 200, height: 46), cornerRadius: 12)
        btn.fillColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        btn.strokeColor = UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1.0)
        btn.lineWidth = 1.5
        btn.position = CGPoint(x: size.width / 2, y: size.height / 2 - 30)
        btn.name = "restartBtn"
        btn.zPosition = 21
        let btnLabel = SKLabelNode(text: "BACK TO MENU")
        btnLabel.fontSize = 15
        btnLabel.fontColor = UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1.0)
        btnLabel.fontName = "AvenirNext-Bold"
        btnLabel.verticalAlignmentMode = .center
        btnLabel.name = "restartBtn"
        btn.addChild(btnLabel)
        addChild(btn)
    }
    
    func jump() {
        if isOnGround {
            isOnGround = false
            jumpsUsed = 1
            umbraBody.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 80))
        } else if hasDoubleJump && jumpsUsed < 2 {
            jumpsUsed = 2
            umbraBody.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            umbraBody.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 80))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node = atPoint(location)
            let name = node.name ?? node.parent?.name ?? ""
            if name == "leftBtn" { movingLeft = true; facingRight = false }
            if name == "rightBtn" { movingRight = true; facingRight = true }
            if name == "jumpBtn" { jump() }
            if name == "attackBtn" { shoot() }
            if name == "restartBtn" {
                let menu = MenuScene(size: size)
                menu.scaleMode = scaleMode
                view?.presentScene(menu, transition: SKTransition.fade(withDuration: 0.8))
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node = atPoint(location)
            let name = node.name ?? node.parent?.name ?? ""
            if name == "leftBtn" { movingLeft = false }
            if name == "rightBtn" { movingRight = false }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if movingLeft { umbraBody.position.x -= moveSpeed }
        if movingRight { umbraBody.position.x += moveSpeed }
        if let sprite = umbraBody.childNode(withName: "umbraSprite") as? SKSpriteNode {
            sprite.xScale = facingRight ? 1.0 : -1.0
        }
    }
}

extension Stage3Scene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let nameA = contact.bodyA.node?.name ?? ""
        let nameB = contact.bodyB.node?.name ?? ""
        if (nameA == "umbra" && nameB == "ground") ||
           (nameB == "umbra" && nameA == "ground") {
            isOnGround = true
            jumpsUsed = 0
        }
    }
}
