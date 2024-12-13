//
//  GameScene.swift
//  Umbra
//
//  Created by Cat on 12/10/24.
//
import SpriteKit

class GameScene: SKScene {
    
    var umbra: SKNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        spawnUmbra()
    }
    
    func spawnUmbra() {
        umbra = SKNode()
        umbra.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        // Body
        let body = SKShapeNode(circleOfRadius: 30)
        body.fillColor = .white
        body.strokeColor = .clear
        umbra.addChild(body)
        
        // Left eye
        let leftEye = SKShapeNode(circleOfRadius: 6)
        leftEye.fillColor = .black
        leftEye.strokeColor = .clear
        leftEye.position = CGPoint(x: -10, y: 8)
        umbra.addChild(leftEye)
        
        // Right eye
        let rightEye = SKShapeNode(circleOfRadius: 6)
        rightEye.fillColor = .black
        rightEye.strokeColor = .clear
        rightEye.position = CGPoint(x: 10, y: 8)
        umbra.addChild(rightEye)
        
        addChild(umbra)
    }
}
