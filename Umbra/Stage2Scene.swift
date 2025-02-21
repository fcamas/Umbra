//
//  Stage2Scene.swift
//  Umbra
//
//  Created by Fredy C on 1/5/25.
//


import SpriteKit

class Stage2Scene: SKScene {
    
    var hasFire = false
    var fireOrb: SKNode!
    var enemiesKilled = 0
    var joystick: JoystickNode!
    
    
    var enemy1: SKNode!
    var enemy2: SKNode!
    var enemy1MovingRight = true
    var enemy2MovingRight = false
    let enemySpeed: CGFloat = 2.5
    var enemy1Alive = true
    var enemy2Alive = true
    
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
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        
        buildStage2()
        spawnUmbra()
        spawnEnemies()
        addButtons()
        addHealthBar()
        addStageLabel()
        spawnFireOrb()
        
    }
    
    func buildStage2() {
        // Darker background tint
        let bg = SKSpriteNode(imageNamed: "cave_bg")
        bg.size = CGSize(width: size.width, height: size.height)
        bg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        bg.zPosition = -1
        bg.color = UIColor(red: 0.5, green: 0.2, blue: 0.2, alpha: 1.0)
        bg.colorBlendFactor = 0.4
        addChild(bg)
        
        // Different platform layout
        let platforms: [(x: CGFloat, y: CGFloat, w: CGFloat)] = [
            (size.width / 2, 80, size.width),           // ground
            (size.width * 0.2, 170, 180),               // left low
            (size.width * 0.5, 210, 200),               // center mid
            (size.width * 0.8, 170, 180),               // right low
            (size.width * 0.3, 270, 160),               // left high
            (size.width * 0.7, 270, 160),               // right high
        ]
        
        for (index, p) in platforms.enumerated() {
            let plat = SKShapeNode(rectOf: CGSize(width: p.w, height: 18))
            
            if index == 0 {
                plat.fillColor = .clear
                plat.strokeColor = .clear
            } else {
                plat.fillColor = UIColor(red: 0.3, green: 0.05, blue: 0.05, alpha: 0.9)
                plat.strokeColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0)
                plat.lineWidth = 1.5
            }
            
            plat.position = CGPoint(x: p.x, y: p.y)
            plat.name = "ground"
            plat.zPosition = 1
            plat.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: p.w, height: 18))
            plat.physicsBody?.isDynamic = false
            plat.physicsBody?.categoryBitMask = 0x1 << 1
            plat.physicsBody?.contactTestBitMask = 0x1 << 0
            plat.physicsBody?.collisionBitMask = 0x1 << 0
            addChild(plat)
        }
        
        let leftWall = SKShapeNode(rectOf: CGSize(width: 18, height: size.height))
        leftWall.fillColor = .clear
        leftWall.strokeColor = .clear
        leftWall.position = CGPoint(x: 9, y: size.height / 2)
        leftWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 18, height: size.height))
        leftWall.physicsBody?.isDynamic = false
        addChild(leftWall)
        
        let rightWall = SKShapeNode(rectOf: CGSize(width: 18, height: size.height))
        rightWall.fillColor = .clear
        rightWall.strokeColor = .clear
        rightWall.position = CGPoint(x: size.width - 9, y: size.height / 2)
        rightWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 18, height: size.height))
        rightWall.physicsBody?.isDynamic = false
        addChild(rightWall)
    }
    
    func spawnUmbra() {
        umbraBody = SKNode()
        umbraBody.position = CGPoint(x: 60, y: 120)
        umbraBody.name = "umbra"
        
        umbraBody.physicsBody = SKPhysicsBody(circleOfRadius: 30)
        umbraBody.physicsBody?.allowsRotation = false
        umbraBody.physicsBody?.contactTestBitMask = 0x1 << 1 | 0x1 << 3 | 0x1 << 4 | 0x1 << 5
        umbraBody.physicsBody?.contactTestBitMask = 0x1 << 1 | 0x1 << 3
        umbraBody.physicsBody?.collisionBitMask = 0x1 << 1
        
        let sprite = SKSpriteNode(imageNamed: "umbra")
        sprite.size = CGSize(width: 110, height: 110)
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
        let bgBar = SKShapeNode(rectOf: CGSize(width: 154, height: 18), cornerRadius: 4)
        bgBar.fillColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        bgBar.strokeColor = .clear
        bgBar.position = CGPoint(x: 97, y: size.height - 30)
        bgBar.zPosition = 10
        addChild(bgBar)
        
        healthBar = SKShapeNode(rectOf: CGSize(width: 150, height: 14), cornerRadius: 3)
        healthBar.fillColor = UIColor(red: 0.2, green: 0.9, blue: 0.3, alpha: 1.0)
        healthBar.strokeColor = .clear
        healthBar.position = CGPoint(x: 97, y: size.height - 30)
        healthBar.zPosition = 11
        addChild(healthBar)
        
        let hp = SKLabelNode(text: "HP")
        hp.fontSize = 13
        hp.fontColor = .white
        hp.position = CGPoint(x: 22, y: size.height - 36)
        hp.zPosition = 11
        addChild(hp)
    }
    
    func addStageLabel() {
        let label = SKLabelNode(text: "STAGE 2")
        label.fontSize = 22
        label.fontColor = UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1.0)
        label.fontName = "AvenirNext-Bold"
        label.position = CGPoint(x: size.width / 2, y: size.height - 60)
        label.zPosition = 10
        addChild(label)
        
        let fadeOut = SKAction.fadeOut(withDuration: 2.0)
        let remove = SKAction.removeFromParent()
        label.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), fadeOut, remove]))
    }
    
    func addButtons() {
        joystick = JoystickNode()
        joystick.position = CGPoint(x: 80, y: 60)
        joystick.zPosition = 10
        joystick.onMove = { [weak self] value in
            guard let self = self else { return }
            if value < -0.2 {
                self.movingLeft = true
                self.movingRight = false
                self.facingRight = false
            } else if value > 0.2 {
                self.movingRight = true
                self.movingLeft = false
                self.facingRight = true
            } else {
                self.movingLeft = false
                self.movingRight = false
            }
        }
        joystick.onJump = { [weak self] in
            self?.jump()
        }
        addChild(joystick)
        
        let jumpBtn = SKShapeNode(circleOfRadius: 28)
        jumpBtn.fillColor = UIColor(white: 0.2, alpha: 0.8)
        jumpBtn.strokeColor = UIColor(white: 0.5, alpha: 0.5)
        jumpBtn.lineWidth = 1.5
        jumpBtn.position = CGPoint(x: size.width - 50, y: 55)
        jumpBtn.name = "jumpBtn"
        jumpBtn.zPosition = 10
        let jumpLabel = SKLabelNode(text: "^")
        jumpLabel.fontSize = 22
        jumpLabel.verticalAlignmentMode = .center
        jumpBtn.addChild(jumpLabel)
        addChild(jumpBtn)
        
        let attackBtn = SKShapeNode(circleOfRadius: 28)
        attackBtn.fillColor = UIColor(red: 0.5, green: 0.1, blue: 0.1, alpha: 0.8)
        attackBtn.strokeColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 0.8)
        attackBtn.lineWidth = 1.5
        attackBtn.position = CGPoint(x: size.width - 115, y: 55)
        attackBtn.name = "attackBtn"
        attackBtn.zPosition = 10
        let attackLabel = SKLabelNode(text: "X")
        attackLabel.fontSize = 22
        attackLabel.verticalAlignmentMode = .center
        attackBtn.addChild(attackLabel)
        addChild(attackBtn)
    }
    
    func shoot() {
        let ball = SKShapeNode(circleOfRadius: 8)
        
        if hasFire {
            ball.fillColor = UIColor(red: 1.0, green: 0.5, blue: 0.1, alpha: 1.0)
        } else {
            ball.fillColor = UIColor(red: 0.9, green: 0.8, blue: 0.2, alpha: 1.0)
        }
        
        ball.strokeColor = .clear
        ball.position = umbraBody.position
        ball.name = "projectile"
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 8)
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
        healthBar.position.x = 97 - (150 - 150 * ratio) / 2
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
        label.fontSize = 48
        label.fontColor = .red
        label.fontName = "AvenirNext-Bold"
        label.position = CGPoint(x: size.width / 2, y: size.height / 2 + 40)
        label.zPosition = 21
        addChild(label)
        let btn = SKShapeNode(rectOf: CGSize(width: 200, height: 50), cornerRadius: 12)
        btn.fillColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        btn.strokeColor = UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1.0)
        btn.lineWidth = 1.5
        btn.position = CGPoint(x: size.width / 2, y: size.height / 2 - 30)
        btn.name = "restartBtn"
        btn.zPosition = 21
        let btnLabel = SKLabelNode(text: "BACK TO MENU")
        btnLabel.fontSize = 16
        btnLabel.fontColor = UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1.0)
        btnLabel.fontName = "AvenirNext-Bold"
        btnLabel.verticalAlignmentMode = .center
        btnLabel.name = "restartBtn"
        btn.addChild(btnLabel)
        addChild(btn)
    }
    
    func jump() {
        guard isOnGround else { return }
        isOnGround = false
        umbraBody.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 120))
    }
    
    func spawnEnemies() {
        // Enemy 1 — left platform
        enemy1 = SKNode()
        enemy1.position = CGPoint(x: size.width * 0.2, y: 200)
        enemy1.name = "enemy"
        
        enemy1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        enemy1.physicsBody?.allowsRotation = false
        enemy1.physicsBody?.categoryBitMask = 0x1 << 3
        enemy1.physicsBody?.contactTestBitMask = 0x1 << 2 | 0x1 << 0
        enemy1.physicsBody?.collisionBitMask = 0x1 << 1
        
        let sprite1 = SKSpriteNode(imageNamed: "enemy_sprite")
        sprite1.size = CGSize(width: 64, height: 64)
        sprite1.name = "enemyBody"
        enemy1.addChild(sprite1)
        
        let pulse1 = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.5, duration: 0.4),
            SKAction.fadeAlpha(to: 1.0, duration: 0.4)
        ])
        sprite1.run(SKAction.repeatForever(pulse1))
        addChild(enemy1)
        
        // Enemy 2 — right platform
        enemy2 = SKNode()
        enemy2.position = CGPoint(x: size.width * 0.8, y: 200)
        enemy2.name = "enemy"
        
        enemy2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        enemy2.physicsBody?.allowsRotation = false
        enemy2.physicsBody?.categoryBitMask = 0x1 << 3
        enemy2.physicsBody?.contactTestBitMask = 0x1 << 2 | 0x1 << 0
        enemy2.physicsBody?.collisionBitMask = 0x1 << 1
        
        let sprite2 = SKSpriteNode(imageNamed: "enemy_sprite")
        sprite2.size = CGSize(width: 64, height: 64)
        sprite2.name = "enemyBody"
        enemy2.addChild(sprite2)
        
        let pulse2 = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.5, duration: 0.3),
            SKAction.fadeAlpha(to: 1.0, duration: 0.3)
        ])
        sprite2.run(SKAction.repeatForever(pulse2))
        addChild(enemy2)
    }

    func killEnemy1() {
        guard enemy1Alive else { return }
        enemy1Alive = false
        let fade = SKAction.fadeOut(withDuration: 0.3)
        let remove = SKAction.removeFromParent()
        enemy1.run(SKAction.sequence([fade, remove]))
        checkAllEnemiesDead()
    }

    func killEnemy2() {
        guard enemy2Alive else { return }
        enemy2Alive = false
        let fade = SKAction.fadeOut(withDuration: 0.3)
        let remove = SKAction.removeFromParent()
        enemy2.run(SKAction.sequence([fade, remove]))
        checkAllEnemiesDead()
    }
    
    func spawnFireOrb() {
        fireOrb = SKNode()
        fireOrb.position = CGPoint(x: size.width / 2, y: 160)
        fireOrb.name = "fireOrb"
        
        // Orb glow ring
        let ring = SKShapeNode(circleOfRadius: 18)
        ring.fillColor = UIColor(red: 1.0, green: 0.4, blue: 0.1, alpha: 0.3)
        ring.strokeColor = UIColor(red: 1.0, green: 0.5, blue: 0.1, alpha: 1.0)
        ring.lineWidth = 2
        fireOrb.addChild(ring)
        
        // Orb core
        let core = SKShapeNode(circleOfRadius: 10)
        core.fillColor = UIColor(red: 1.0, green: 0.6, blue: 0.1, alpha: 1.0)
        core.strokeColor = .clear
        fireOrb.addChild(core)
        
        // Label
        let label = SKLabelNode(text: "FIRE")
        label.fontSize = 9
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        fireOrb.addChild(label)
        
        // Pulse
        let pulse = SKAction.sequence([
            SKAction.scale(to: 1.2, duration: 0.6),
            SKAction.scale(to: 1.0, duration: 0.6)
        ])
        fireOrb.run(SKAction.repeatForever(pulse))
        
        fireOrb.physicsBody = SKPhysicsBody(circleOfRadius: 18)
        fireOrb.physicsBody?.isDynamic = false
        fireOrb.physicsBody?.categoryBitMask = 0x1 << 4
        fireOrb.physicsBody?.contactTestBitMask = 0x1 << 0
        fireOrb.physicsBody?.collisionBitMask = 0
        
        addChild(fireOrb)
    }

    func collectFireOrb() {
        hasFire = true
        fireOrb.removeFromParent()
        
        let collected = SKLabelNode(text: "FIRE BEAM GET!")
        collected.fontSize = 20
        collected.fontColor = UIColor(red: 1.0, green: 0.5, blue: 0.1, alpha: 1.0)
        collected.position = CGPoint(x: size.width / 2, y: size.height / 2 + 40)
        collected.zPosition = 20
        addChild(collected)
        
        let fadeOut = SKAction.fadeOut(withDuration: 1.5)
        let remove = SKAction.removeFromParent()
        collected.run(SKAction.sequence([fadeOut, remove]))
    }
    
    func checkAllEnemiesDead() {
        enemiesKilled += 1
        guard enemiesKilled >= 2 else { return }
        
        let door = SKShapeNode(rectOf: CGSize(width: 24, height: 64), cornerRadius: 6)
        door.fillColor = UIColor(red: 0.0, green: 0.1, blue: 0.5, alpha: 0.9)
        door.strokeColor = UIColor(red: 0.2, green: 0.4, blue: 1.0, alpha: 1.0)
        door.lineWidth = 2
        door.position = CGPoint(x: size.width / 2, y: 130)
        door.name = "stage3Door"
        door.zPosition = 2
        
        let pulse = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.5, duration: 0.6),
            SKAction.fadeAlpha(to: 1.0, duration: 0.6)
        ])
        door.run(SKAction.repeatForever(pulse))
        
        let label = SKLabelNode(text: "STAGE 3")
        label.fontSize = 10
        label.fontColor = UIColor(red: 0.2, green: 0.4, blue: 1.0, alpha: 1.0)
        label.fontName = "AvenirNext-Bold"
        label.position = CGPoint(x: 0, y: 38)
        door.addChild(label)
        
        door.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 24, height: 64))
        door.physicsBody?.isDynamic = false
        door.physicsBody?.categoryBitMask = 0x1 << 5
        door.physicsBody?.contactTestBitMask = 0x1 << 0
        door.physicsBody?.collisionBitMask = 0
        addChild(door)
        
        let msg = SKLabelNode(text: "ALL CLEAR!")
        msg.fontSize = 24
        msg.fontColor = UIColor(red: 0.2, green: 0.4, blue: 1.0, alpha: 1.0)
        msg.fontName = "AvenirNext-Bold"
        msg.position = CGPoint(x: size.width / 2, y: size.height / 2 + 30)
        msg.zPosition = 20
        addChild(msg)
        let fade = SKAction.fadeOut(withDuration: 1.5)
        let remove = SKAction.removeFromParent()
        msg.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), fade, remove]))
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
        if enemy1Alive {
            if enemy1MovingRight {
                enemy1.position.x += enemySpeed
                if enemy1.position.x > size.width * 0.38 { enemy1MovingRight = false }
            } else {
                enemy1.position.x -= enemySpeed
                if enemy1.position.x < size.width * 0.08 { enemy1MovingRight = true }
            }
        }

        if enemy2Alive {
            if enemy2MovingRight {
                enemy2.position.x += enemySpeed
                if enemy2.position.x > size.width * 0.95 { enemy2MovingRight = false }
            } else {
                enemy2.position.x -= enemySpeed
                if enemy2.position.x < size.width * 0.65 { enemy2MovingRight = true }
            }
        }
    }
}

extension Stage2Scene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let nameA = contact.bodyA.node?.name ?? ""
        let nameB = contact.bodyB.node?.name ?? ""
        
        
        if (nameA == "umbra" && nameB == "fireOrb") ||
           (nameB == "umbra" && nameA == "fireOrb") {
            collectFireOrb()
        }
        
        if (nameA == "umbra" && nameB == "stage3Door") ||
           (nameB == "umbra" && nameA == "stage3Door") {
            let stage3 = Stage3Scene(size: size)
            stage3.scaleMode = scaleMode
            view?.presentScene(stage3, transition: SKTransition.fade(withDuration: 1.0))
        }
        
        if (nameA == "umbra" && nameB == "ground") ||
           (nameB == "umbra" && nameA == "ground") {
            isOnGround = true
        }
        
        if (nameA == "projectile" && nameB == "enemy") ||
           (nameB == "projectile" && nameA == "enemy") {
            
            // Remove projectile
            if nameA == "projectile" {
                contact.bodyA.node?.removeFromParent()
            } else {
                contact.bodyB.node?.removeFromParent()
            }
            
            // Figure out which enemy was hit
            let enemyNode = nameA == "enemy" ? contact.bodyA.node : contact.bodyB.node
            
            if enemyNode === enemy1 && enemy1Alive {
                killEnemy1()
            } else if enemyNode === enemy2 && enemy2Alive {
                killEnemy2()
            }
        }
        
        if (nameA == "umbra" && nameB == "enemy") ||
           (nameB == "umbra" && nameA == "enemy") {
            takeDamage()
        }
    }
}
