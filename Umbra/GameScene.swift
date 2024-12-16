//
//  GameScene.swift
//  Umbra
//
//  Created by Cat on 12/10/24.
//
import SpriteKit

class GameScene: SKScene {
    
    var umbra: SKNode!
    var movingLeft = false
    var movingRight = false
    let moveSpeed: CGFloat = 3.0
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        spawnUmbra()
        addButtons()
    }
    
    func spawnUmbra() {
        umbra = SKNode()
        umbra.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        let body = SKShapeNode(circleOfRadius: 30)
        body.fillColor = .white
        body.strokeColor = .clear
        umbra.addChild(body)
        
        let leftEye = SKShapeNode(circleOfRadius: 6)
        leftEye.fillColor = .black
        leftEye.strokeColor = .clear
        leftEye.position = CGPoint(x: -10, y: 8)
        umbra.addChild(leftEye)
        
        let rightEye = SKShapeNode(circleOfRadius: 6)
        rightEye.fillColor = .black
        rightEye.strokeColor = .clear
        rightEye.position = CGPoint(x: 10, y: 8)
        umbra.addChild(rightEye)
        
        addChild(umbra)
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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node = atPoint(location)
            if node.name == "leftBtn" || node.parent?.name == "leftBtn" { movingLeft = true }
            if node.name == "rightBtn" || node.parent?.name == "rightBtn" { movingRight = true }
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
    
    override func update(_ currentTime: TimeInterval) {
        if movingLeft { umbra.position.x -= moveSpeed }
        if movingRight { umbra.position.x += moveSpeed }
    }
}
