//
//  GameScene.swift
//  Umbra
//
//  Created by Cat on 12/10/24.
//
import SpriteKit

class GameScene: SKScene {
    
    var umbra: SKSpriteNode!
    var umbraBody: SKNode!
    var movingLeft = false
    var movingRight = false
    let moveSpeed: CGFloat = 5.0
    var isOnGround = false
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        // World gravity
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        
        spawnGround()
        spawnUmbra()
        addButtons()
    }
    
    func spawnGround() {
        let ground = SKShapeNode(rectOf: CGSize(width: size.width, height: 20))
        ground.fillColor = .darkGray
        ground.strokeColor = .clear
        ground.position = CGPoint(x: size.width / 2, y: 60)
        ground.name = "ground"
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 20))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = 0x1 << 1
        ground.physicsBody?.contactTestBitMask = 0x1 << 0
        
        addChild(ground)
    }
    
    func spawnUmbra() {
        umbraBody = SKNode()
        umbraBody.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        // Physics
        umbraBody.physicsBody = SKPhysicsBody(circleOfRadius: 30)
        umbraBody.physicsBody?.allowsRotation = false
        umbraBody.physicsBody?.categoryBitMask = 0x1 << 0
        umbraBody.physicsBody?.contactTestBitMask = 0x1 << 1
        umbraBody.physicsBody?.collisionBitMask = 0x1 << 1
        
        // Body
        let body = SKShapeNode(circleOfRadius: 30)
        body.fillColor = .white
        body.strokeColor = .clear
        umbraBody.addChild(body)
        
        // Left eye
        let leftEye = SKShapeNode(circleOfRadius: 6)
        leftEye.fillColor = .black
        leftEye.strokeColor = .clear
        leftEye.position = CGPoint(x: -10, y: 8)
        umbraBody.addChild(leftEye)
        
        // Right eye
        let rightEye = SKShapeNode(circleOfRadius: 6)
        rightEye.fillColor = .black
        rightEye.strokeColor = .clear
        rightEye.position = CGPoint(x: 10, y: 8)
        umbraBody.addChild(rightEye)
        
        addChild(umbraBody)
    }
    
    func addButtons() {
        // Left button
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
        
        // Right button
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
        
        // Jump button
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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node = atPoint(location)
            if node.name == "leftBtn" || node.parent?.name == "leftBtn" { movingLeft = true }
            if node.name == "rightBtn" || node.parent?.name == "rightBtn" { movingRight = true }
            if node.name == "jumpBtn" || node.parent?.name == "jumpBtn" { jump() }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node = atPoint(location)
            if node.name == "leftBtn" || node.parent?.name == "leftBtn" { movingLeft = false }
            if node.name == "rightBtn" || node.parent?.name == "rightBtn" { movingRight = false }
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
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        isOnGround = true
    }
}
