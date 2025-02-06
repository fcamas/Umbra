//
//  GameScene.swift
//  Umbra
//
//  Created by Fredy C on 12/10/24.
//
import SpriteKit

class GameScene: SKScene {
    
    var umbraBody: SKNode!
    var movingLeft = false
    var movingRight = false
    let moveSpeed: CGFloat = 5.0
    var isOnGround = false
    var facingRight = true
    
    // Health
    var health: CGFloat = 100
    let maxHealth: CGFloat = 100
    var healthBar: SKShapeNode!
    var invincible = false
    
    // Power up
    var hasIce = false
    var powerUpOrb: SKNode!
    var powerUpLabel: SKLabelNode!
    
    // Enemy
    var enemy: SKNode!
    var enemyMovingRight = true
    var enemySpeed: CGFloat = 2.0
    var bossHealth: Int = 5
    var bossDeathPosition: CGPoint = .zero
    var enemyAlive = true
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        
        buildStage()
        spawnUmbra()
        spawnEnemy()
        spawnPowerUp()
        addButtons()
        addHealthBar()
        addPowerUpHUD()
    }
    
    func enterStage2() {
        let stage2 = Stage2Scene(size: size)
        stage2.scaleMode = scaleMode
        let transition = SKTransition.fade(withDuration: 1.0)
        view?.presentScene(stage2, transition: transition)
    }
    
    
    func buildStage() {
        // Cave background
        let bg = SKSpriteNode(imageNamed: "cave_bg")
        bg.size = CGSize(width: size.width, height: size.height)
        bg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        bg.zPosition = -1
        addChild(bg)
        
        let platforms: [(x: CGFloat, y: CGFloat, w: CGFloat)] = [
            (size.width / 2, 80, size.width),           // ground
            (size.width * 0.2, 160, 200),               // left low
            (size.width * 0.5, 200, 220),               // center mid
            (size.width * 0.8, 160, 200),               // right low
            (size.width * 0.3, 260, 160),               // left high
            (size.width * 0.7, 260, 160),               // right high
        ]
        
        for (index, p) in platforms.enumerated() {
            let plat = SKShapeNode(rectOf: CGSize(width: p.w, height: 18))
            
            if index == 0 {
                // Ground — invisible visually but physics still solid
                plat.fillColor = .clear
                plat.strokeColor = .clear
            } else {
                plat.fillColor = UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 0.9)
                plat.strokeColor = UIColor(red: 0.5, green: 0.3, blue: 0.7, alpha: 1.0)
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
        leftWall.fillColor = UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 0.9)
        leftWall.strokeColor = .clear
        leftWall.position = CGPoint(x: 9, y: size.height / 2)
        leftWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 18, height: size.height))
        leftWall.physicsBody?.isDynamic = false
        addChild(leftWall)
        
        let rightWall = SKShapeNode(rectOf: CGSize(width: 18, height: size.height))
        rightWall.fillColor = UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 0.9)
        rightWall.strokeColor = .clear
        rightWall.position = CGPoint(x: size.width - 9, y: size.height / 2)
        rightWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 18, height: size.height))
        rightWall.physicsBody?.isDynamic = false
        addChild(rightWall)

        
    }
    
    func spawnUmbra() {
        umbraBody = SKNode()
        umbraBody.position = CGPoint(x: size.width / 2, y: 120)
        umbraBody.name = "umbra"
        
        umbraBody.physicsBody = SKPhysicsBody(circleOfRadius: 30)
        umbraBody.physicsBody?.allowsRotation = false
        umbraBody.physicsBody?.categoryBitMask = 0x1 << 0
        umbraBody.physicsBody?.contactTestBitMask = 0x1 << 1 | 0x1 << 3 | 0x1 << 4 | 0x1 << 5
        umbraBody.physicsBody?.collisionBitMask = 0x1 << 1
        
        // Real Umbra sprite
        let sprite = SKSpriteNode(imageNamed: "umbra")
        sprite.size = CGSize(width: 110, height: 110)
        sprite.position = CGPoint(x: 0, y: 0)
        sprite.name = "umbraSprite"
        umbraBody.addChild(sprite)
        // Idle float animation
        let floatUp = SKAction.moveBy(x: 0, y: 6, duration: 0.8)
        let floatDown = SKAction.moveBy(x: 0, y: -6, duration: 0.8)
        floatUp.timingMode = .easeInEaseOut
        floatDown.timingMode = .easeInEaseOut
        let float = SKAction.repeatForever(SKAction.sequence([floatUp, floatDown]))
        if let sprite = umbraBody.childNode(withName: "umbraSprite") {
            sprite.run(float)
        }
        addChild(umbraBody)
    }
    
    func spawnEnemy() {
        enemy = SKNode()
        enemy.position = CGPoint(x: size.width / 2, y: 100)
        enemy.name = "enemy"
        
        // Boss is 2x size
        enemy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 100))
        enemy.physicsBody?.allowsRotation = false
        enemy.physicsBody?.categoryBitMask = 0x1 << 3
        enemy.physicsBody?.contactTestBitMask = 0x1 << 2 | 0x1 << 0
        enemy.physicsBody?.collisionBitMask = 0x1 << 1
        
        let sprite = SKSpriteNode(imageNamed: "enemy_sprite")
        sprite.size = CGSize(width: 120, height: 120)
        sprite.name = "enemyBody"
        enemy.addChild(sprite)
        
        // Health bar above boss
        let bossHpBg = SKShapeNode(rectOf: CGSize(width: 104, height: 12), cornerRadius: 3)
        bossHpBg.fillColor = UIColor(red: 0.3, green: 0.0, blue: 0.0, alpha: 1.0)
        bossHpBg.strokeColor = .clear
        bossHpBg.position = CGPoint(x: 0, y: 72)
        bossHpBg.name = "bossHpBg"
        enemy.addChild(bossHpBg)
        
        let bossHpBar = SKShapeNode(rectOf: CGSize(width: 100, height: 8), cornerRadius: 2)
        bossHpBar.fillColor = UIColor(red: 0.9, green: 0.1, blue: 0.1, alpha: 1.0)
        bossHpBar.strokeColor = .clear
        bossHpBar.position = CGPoint(x: 0, y: 72)
        bossHpBar.name = "bossHpBar"
        enemy.addChild(bossHpBar)
        
        // Boss name label
        let bossLabel = SKLabelNode(text: "SHADOW BEAST")
        bossLabel.fontSize = 11
        bossLabel.fontColor = UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1.0)
        bossLabel.fontName = "AvenirNext-Bold"
        bossLabel.position = CGPoint(x: 0, y: 82)
        bossLabel.name = "bossLabel"
        enemy.addChild(bossLabel)
        
        // Red eye pulse
        let pulse = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.5, duration: 0.3),
            SKAction.fadeAlpha(to: 1.0, duration: 0.3)
        ])
        sprite.run(SKAction.repeatForever(pulse))
        
        addChild(enemy)
    }
    
    func spawnPowerUp() {
        powerUpOrb = SKNode()
        powerUpOrb.position = CGPoint(x: size.width - 180, y: 320)
        powerUpOrb.name = "iceOrb"
        
        // Orb glow ring
        let ring = SKShapeNode(circleOfRadius: 18)
        ring.fillColor = UIColor(red: 0.4, green: 0.8, blue: 1.0, alpha: 0.3)
        ring.strokeColor = UIColor(red: 0.4, green: 0.8, blue: 1.0, alpha: 1.0)
        ring.lineWidth = 2
        powerUpOrb.addChild(ring)
        
        // Orb core
        let core = SKShapeNode(circleOfRadius: 10)
        core.fillColor = UIColor(red: 0.6, green: 0.9, blue: 1.0, alpha: 1.0)
        core.strokeColor = .clear
        powerUpOrb.addChild(core)
        
        // Orb label
        let label = SKLabelNode(text: "ICE")
        label.fontSize = 9
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        powerUpOrb.addChild(label)
        
        // Pulse animation
        let pulse = SKAction.sequence([
            SKAction.scale(to: 1.2, duration: 0.6),
            SKAction.scale(to: 1.0, duration: 0.6)
        ])
        powerUpOrb.run(SKAction.repeatForever(pulse))
        
        // Physics — sensor only
        powerUpOrb.physicsBody = SKPhysicsBody(circleOfRadius: 18)
        powerUpOrb.physicsBody?.isDynamic = false
        powerUpOrb.physicsBody?.categoryBitMask = 0x1 << 4
        powerUpOrb.physicsBody?.contactTestBitMask = 0x1 << 0
        powerUpOrb.physicsBody?.collisionBitMask = 0
        
        addChild(powerUpOrb)
    }
    
    func collectIceOrb() {
        hasIce = true
        powerUpOrb.removeFromParent()
        powerUpLabel.text = "ICE"
        powerUpLabel.fontColor = UIColor(red: 0.4, green: 0.8, blue: 1.0, alpha: 1.0)
        
        // Flash collected message
        let collected = SKLabelNode(text: "ICE BEAM GET!")
        collected.fontSize = 22
        collected.fontColor = UIColor(red: 0.4, green: 0.8, blue: 1.0, alpha: 1.0)
        collected.position = CGPoint(x: size.width / 2, y: size.height / 2 + 60)
        collected.zPosition = 20
        addChild(collected)
        
        let fadeOut = SKAction.fadeOut(withDuration: 1.5)
        let remove = SKAction.removeFromParent()
        collected.run(SKAction.sequence([fadeOut, remove]))
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
        
        let heart = SKLabelNode(text: "HP")
        heart.fontSize = 13
        heart.fontColor = .white
        heart.position = CGPoint(x: 22, y: size.height - 36)
        heart.zPosition = 11
        addChild(heart)
    }
    
    func addPowerUpHUD() {
        let box = SKShapeNode(rectOf: CGSize(width: 60, height: 24), cornerRadius: 4)
        box.fillColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        box.strokeColor = .gray
        box.position = CGPoint(x: size.width - 50, y: size.height - 30)
        box.zPosition = 10
        addChild(box)
        
        powerUpLabel = SKLabelNode(text: "NONE")
        powerUpLabel.fontSize = 12
        powerUpLabel.fontColor = .gray
        powerUpLabel.verticalAlignmentMode = .center
        powerUpLabel.position = CGPoint(x: size.width - 50, y: size.height - 31)
        powerUpLabel.zPosition = 11
        addChild(powerUpLabel)
    }
    
    func updateHealthBar() {
        let ratio = health / maxHealth
        healthBar.xScale = ratio
        healthBar.position.x = 97 - (150 - 150 * ratio) / 2
    }
    
    func takeDamage() {
        guard !invincible else { return }
        invincible = true
        health -= 20
        if health < 0 { health = 0 }
        updateHealthBar()
        
        let fadeOut = SKAction.fadeAlpha(to: 0.2, duration: 0.1)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.1)
        let blink = SKAction.repeat(SKAction.sequence([fadeOut, fadeIn]), count: 4)
        let resetInvincible = SKAction.run { self.invincible = false }
        umbraBody.run(SKAction.sequence([blink, resetInvincible]))
        
        if health <= 0 { gameOver() }
    }
    
    func gameOver() {
        enemyAlive = false
        umbraBody.physicsBody?.isDynamic = false
        
        // Dark overlay
        let overlay = SKShapeNode(rectOf: CGSize(width: size.width, height: size.height))
        overlay.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        overlay.strokeColor = .clear
        overlay.position = CGPoint(x: size.width / 2, y: size.height / 2)
        overlay.zPosition = 20
        addChild(overlay)
        
        // Game Over label
        let label = SKLabelNode(text: "GAME OVER")
        label.fontSize = 48
        label.fontColor = .red
        label.fontName = "AvenirNext-Bold"
        label.position = CGPoint(x: size.width / 2, y: size.height / 2 + 40)
        label.zPosition = 21
        addChild(label)
        
        // Restart button
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
    
    func killEnemy() {
        guard enemyAlive else { return }
        enemyAlive = false
        bossDeathPosition = enemy.position
        
        // Screen shake
        let shakeRight = SKAction.moveBy(x: 10, y: 0, duration: 0.05)
        let shakeLeft = SKAction.moveBy(x: -10, y: 0, duration: 0.05)
        let shakeSeq = SKAction.repeat(SKAction.sequence([shakeRight, shakeLeft]), count: 5)
        self.run(shakeSeq)
        
        // Boss death — flash and explode
        let flash = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.1, duration: 0.1),
            SKAction.fadeAlpha(to: 1.0, duration: 0.1)
        ])
        let flashRepeat = SKAction.repeat(flash, count: 6)
        let fadeOut = SKAction.fadeOut(withDuration: 0.4)
        let spawnDoor = SKAction.run { self.spawnDoorFromBoss() }
        let remove = SKAction.removeFromParent()
        
        enemy.run(SKAction.sequence([flashRepeat, fadeOut, spawnDoor, remove]))
    }
    
    func spawnDoorFromBoss() {
        let door = SKShapeNode(rectOf: CGSize(width: 24, height: 64), cornerRadius: 6)
        door.fillColor = UIColor(red: 0.3, green: 0.1, blue: 0.5, alpha: 0.9)
        door.strokeColor = UIColor(red: 0.7, green: 0.3, blue: 1.0, alpha: 1.0)
        door.lineWidth = 2
        door.position = bossDeathPosition
        door.name = "stageDoor"
        door.zPosition = 2
        door.alpha = 0
        door.setScale(0.1)
        
        // Door rises from death position
        let appear = SKAction.group([
            SKAction.fadeIn(withDuration: 0.5),
            SKAction.scale(to: 1.0, duration: 0.5)
        ])
        
        // Pulse after appearing
        let pulse = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.5, duration: 0.6),
            SKAction.fadeAlpha(to: 1.0, duration: 0.6)
        ])
        
        door.run(SKAction.sequence([appear, SKAction.repeatForever(pulse)]))
        
        // Door label
        let label = SKLabelNode(text: "STAGE 2")
        label.fontSize = 10
        label.fontColor = UIColor(red: 0.7, green: 0.3, blue: 1.0, alpha: 1.0)
        label.fontName = "AvenirNext-Bold"
        label.position = CGPoint(x: 0, y: 38)
        door.addChild(label)
        
        door.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 24, height: 64))
        door.physicsBody?.isDynamic = false
        door.physicsBody?.categoryBitMask = 0x1 << 5
        door.physicsBody?.contactTestBitMask = 0x1 << 0
        door.physicsBody?.collisionBitMask = 0
        
        addChild(door)
        
        // Big YOU WIN flash
        let winLabel = SKLabelNode(text: "BOSS DEFEATED!")
        winLabel.fontSize = 26
        winLabel.fontColor = UIColor(red: 0.7, green: 0.3, blue: 1.0, alpha: 1.0)
        winLabel.fontName = "AvenirNext-Bold"
        winLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + 40)
        winLabel.zPosition = 20
        addChild(winLabel)
        
        let fadeOut = SKAction.fadeOut(withDuration: 1.5)
        let remove = SKAction.removeFromParent()
        winLabel.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), fadeOut, remove]))
    }
    
    func shoot() {
        let ball = SKShapeNode(circleOfRadius: 8)
        
        if hasIce {
            ball.fillColor = UIColor(red: 0.4, green: 0.8, blue: 1.0, alpha: 1.0)
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
        let move = SKAction.moveBy(x: direction * size.width, y: 0, duration: 0.6)
        let remove = SKAction.removeFromParent()
        ball.run(SKAction.sequence([move, remove]))
    }
    
    func addButtons() {
        let leftBtn = SKShapeNode(rectOf: CGSize(width: 60, height: 60), cornerRadius: 10)
        leftBtn.fillColor = .darkGray
        leftBtn.strokeColor = .clear
        leftBtn.position = CGPoint(x: 60, y: 80)
        leftBtn.name = "leftBtn"
        let leftLabel = SKLabelNode(text: "<")
        leftLabel.fontSize = 30
        leftLabel.verticalAlignmentMode = .center
        leftBtn.addChild(leftLabel)
        addChild(leftBtn)
        
        let rightBtn = SKShapeNode(rectOf: CGSize(width: 60, height: 60), cornerRadius: 10)
        rightBtn.fillColor = .darkGray
        rightBtn.strokeColor = .clear
        rightBtn.position = CGPoint(x: 140, y: 80)
        rightBtn.name = "rightBtn"
        let rightLabel = SKLabelNode(text: ">")
        rightLabel.fontSize = 30
        rightLabel.verticalAlignmentMode = .center
        rightBtn.addChild(rightLabel)
        addChild(rightBtn)
        
        let jumpBtn = SKShapeNode(rectOf: CGSize(width: 60, height: 60), cornerRadius: 10)
        jumpBtn.fillColor = .darkGray
        jumpBtn.strokeColor = .clear
        jumpBtn.position = CGPoint(x: size.width - 60, y: 80)
        jumpBtn.name = "jumpBtn"
        let jumpLabel = SKLabelNode(text: "^")
        jumpLabel.fontSize = 30
        jumpLabel.verticalAlignmentMode = .center
        jumpBtn.addChild(jumpLabel)
        addChild(jumpBtn)
        
        let attackBtn = SKShapeNode(rectOf: CGSize(width: 60, height: 60), cornerRadius: 10)
        attackBtn.fillColor = UIColor(red: 0.6, green: 0.1, blue: 0.1, alpha: 1.0)
        attackBtn.strokeColor = .clear
        attackBtn.position = CGPoint(x: size.width - 140, y: 80)
        attackBtn.name = "attackBtn"
        let attackLabel = SKLabelNode(text: "X")
        attackLabel.fontSize = 30
        attackLabel.verticalAlignmentMode = .center
        attackBtn.addChild(attackLabel)
        addChild(attackBtn)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node = atPoint(location)
            let name = node.name ?? node.parent?.name ?? ""
            if name == "restartBtn" {
                let menu = MenuScene(size: size)
                menu.scaleMode = scaleMode
                let transition = SKTransition.fade(withDuration: 0.8)
                view?.presentScene(menu, transition: transition)
            }
            if name == "leftBtn" { movingLeft = true; facingRight = false }
            if name == "rightBtn" { movingRight = true; facingRight = true }
            if name == "jumpBtn" { jump() }
            if name == "attackBtn" { shoot() }
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
    
    func jump() {
        guard isOnGround else { return }
        isOnGround = false
        umbraBody.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 120))
    }
    
    override func update(_ currentTime: TimeInterval) {
        if movingLeft { umbraBody.position.x -= moveSpeed }
        if movingRight { umbraBody.position.x += moveSpeed }
        
        if enemyAlive {
            if enemyMovingRight {
                enemy.position.x += enemySpeed
                if enemy.position.x > 290 { enemyMovingRight = false }
            } else {
                enemy.position.x -= enemySpeed
                if enemy.position.x < 110 { enemyMovingRight = true }
            }
        }
        // Flip sprite based on direction
        if let sprite = umbraBody.childNode(withName: "umbraSprite") as? SKSpriteNode {
            sprite.xScale = facingRight ? 1.0 : -1.0
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let nameA = contact.bodyA.node?.name ?? ""
        let nameB = contact.bodyB.node?.name ?? ""
        
        if (nameA == "umbra" && nameB == "ground") ||
           (nameB == "umbra" && nameA == "ground") {
            isOnGround = true
        }
        
        if (nameA == "projectile" && nameB == "enemy") ||
           (nameB == "projectile" && nameA == "enemy") {
            
            // Remove projectile only
            if nameA == "projectile" {
                contact.bodyA.node?.removeFromParent()
            } else {
                contact.bodyB.node?.removeFromParent()
            }
            
            // Guard against multiple hits
            guard enemyAlive && bossHealth > 0 else { return }
            
            bossHealth -= 1
            print("Boss health: \(bossHealth)")
            
            // Update boss health bar
            if let bar = enemy.childNode(withName: "bossHpBar") as? SKShapeNode {
                let ratio = CGFloat(bossHealth) / 5.0
                bar.xScale = ratio
            }
            
            // Boss gets faster and angrier when low health
            if bossHealth == 2 {
                enemySpeed = 4.0
                if let sprite = enemy.childNode(withName: "enemyBody") as? SKSpriteNode {
                    sprite.color = UIColor.red
                    sprite.colorBlendFactor = 0.5
                }
            }
            
            if bossHealth <= 0 {
                killEnemy()
            }
        }
        
        if (nameA == "umbra" && nameB == "enemy") ||
           (nameB == "umbra" && nameA == "enemy") {
            takeDamage()
        }
        
        if (nameA == "umbra" && nameB == "iceOrb") ||
           (nameB == "umbra" && nameA == "iceOrb") {
            collectIceOrb()
        }
        if (nameA == "umbra" && nameB == "stageDoor") ||
           (nameB == "umbra" && nameA == "stageDoor") {
            enterStage2()
        }
    }
}
