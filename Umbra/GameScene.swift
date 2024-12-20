//
//  GameScene.swift
//  Umbra
//
//  Created by Cat on 12/10/24.
//
import SpriteKit

class GameScene: SKScene {
    
    var umbraBody: SKNode!
    var movingLeft = false
    var movingRight = false
    let moveSpeed: CGFloat = 5.0
    var isOnGround = false
    var facingRight = true
    
    // Enemy
    var enemy: SKNode!
    var enemyMovingRight = true
    let enemySpeed: CGFloat = 2.0
    var enemyAlive = true
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        
        buildStage()
        spawnUmbra()
        spawnEnemy()
        addButtons()
    }
    
    func buildStage() {
        let platforms: [(x: CGFloat, y: CGFloat, w: CGFloat)] = [
            (size.width / 2, 60, size.width),
            (200, 200, 180),
            (size.width - 180, 280, 180),
            (size.width / 2, 360, 160),
            (100, 420, 120),
        ]
        
        for p in platforms {
            let plat = SKShapeNode(rectOf: CGSize(width: p.w, height: 18))
            plat.fillColor = UIColor(red: 0.2, green: 0.8, blue: 0.6, alpha: 1.0)
            plat.strokeColor = .clear
            plat.position = CGPoint(x: p.x, y: p.y)
            plat.name = "ground"
            plat.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: p.w, height: 18))
            plat.physicsBody?.isDynamic = false
            plat.physicsBody?.categoryBitMask = 0x1 << 1
            plat.physicsBody?.contactTestBitMask = 0x1 << 0
            plat.physicsBody?.collisionBitMask = 0x1 << 0
            addChild(plat)
        }
        
        let leftWall = SKShapeNode(rectOf: CGSize(width: 18, height: size.height))
        leftWall.fillColor = UIColor(red: 0.2, green: 0.8, blue: 0.6, alpha: 1.0)
        leftWall.strokeColor = .clear
        leftWall.position = CGPoint(x: 9, y: size.height / 2)
        leftWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 18, height: size.height))
        leftWall.physicsBody?.isDynamic = false
        addChild(leftWall)
        
        let rightWall = SKShapeNode(rectOf: CGSize(width: 18, height: size.height))
        rightWall.fillColor = UIColor(red: 0.2, green: 0.8, blue: 0.6, alpha: 1.0)
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
        umbraBody.physicsBody?.contactTestBitMask = 0x1 << 1
        umbraBody.physicsBody?.collisionBitMask = 0x1 << 1
        
        let body = SKShapeNode(circleOfRadius: 30)
        body.fillColor = .white
        body.strokeColor = .clear
        umbraBody.addChild(body)
        
        let leftEye = SKShapeNode(circleOfRadius: 6)
        leftEye.fillColor = .black
        leftEye.strokeColor = .clear
        leftEye.position = CGPoint(x: -10, y: 8)
        umbraBody.addChild(leftEye)
        
        let rightEye = SKShapeNode(circleOfRadius: 6)
        rightEye.fillColor = .black
        rightEye.strokeColor = .clear
        rightEye.position = CGPoint(x: 10, y: 8)
        umbraBody.addChild(rightEye)
        
        addChild(umbraBody)
    }
    
    func spawnEnemy() {
        enemy = SKNode()
        enemy.position = CGPoint(x: 200, y: 240)
        enemy.name = "enemy"
        
        enemy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 36, height: 36))
        enemy.physicsBody?.allowsRotation = false
        enemy.physicsBody?.categoryBitMask = 0x1 << 3
        enemy.physicsBody?.contactTestBitMask = 0x1 << 2
        enemy.physicsBody?.collisionBitMask = 0x1 << 1
        
        // Enemy body
        let body = SKShapeNode(rectOf: CGSize(width: 36, height: 36), cornerRadius: 6)
        body.fillColor = UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1.0)
        body.strokeColor = .clear
        body.name = "enemyBody"
        enemy.addChild(body)
        
        // Enemy eyes
        let leftEye = SKShapeNode(circleOfRadius: 5)
        leftEye.fillColor = .white
        leftEye.strokeColor = .clear
        leftEye.position = CGPoint(x: -8, y: 6)
        enemy.addChild(leftEye)
        
        let rightEye = SKShapeNode(circleOfRadius: 5)
        rightEye.fillColor = .white
        rightEye.strokeColor = .clear
        rightEye.position = CGPoint(x: 8, y: 6)
        enemy.addChild(rightEye)
        
        addChild(enemy)
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
    
    func shoot() {
        let ball = SKShapeNode(circleOfRadius: 8)
        ball.fillColor = UIColor(red: 0.9, green: 0.8, blue: 0.2, alpha: 1.0)
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
    
    func killEnemy() {
        guard enemyAlive else { return }
        enemyAlive = false
        
        // Flash red then disappear
        let flash = SKAction.colorize(with: .white, colorBlendFactor: 1.0, duration: 0.1)
        let fade = SKAction.fadeOut(withDuration: 0.3)
        let remove = SKAction.removeFromParent()
        enemy.run(SKAction.sequence([flash, fade, remove]))
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
        
        // Enemy patrol
        if enemyAlive {
            if enemyMovingRight {
                enemy.position.x += enemySpeed
                if enemy.position.x > 290 { enemyMovingRight = false }
            } else {
                enemy.position.x -= enemySpeed
                if enemy.position.x < 110 { enemyMovingRight = true }
            }
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let nameA = contact.bodyA.node?.name ?? ""
        let nameB = contact.bodyB.node?.name ?? ""
        
        // Umbra lands on ground
        if (nameA == "umbra" && nameB == "ground") ||
           (nameB == "umbra" && nameA == "ground") {
            isOnGround = true
        }
        
        // Projectile hits enemy
        if (nameA == "projectile" && nameB == "enemy") ||
           (nameB == "projectile" && nameA == "enemy") {
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            killEnemy()
        }
    }
}
