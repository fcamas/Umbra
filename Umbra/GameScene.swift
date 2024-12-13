//
//  GameScene.swift
//  Umbra
//
//  Created by Cat on 12/10/24.
//
import SpriteKit

class GameScene: SKScene {
    
    let umbra = SKNode()
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        setupUmbra()
    }
    
    func setupUmbra() {
        // Body
        let body = SKShapeNode(circleOfRadius: 30)
        body.fillColor = .init(white: 0.1, alpha: 1)
        body.strokeColor = .darkGray
        
        // Left eye
        let leftEye = SKShapeNode(circleOfRadius: 6)
        leftEye.fillColor = .white
        leftEye.position = CGPoint(x: -10, y: 8)
        
        // Right eye
        let rightEye = SKShapeNode(circleOfRadius: 6)
        rightEye.fillColor = .white
        rightEye.position = CGPoint(x: 10, y: 8)
        
        // Left ear
        let leftEar = SKShapeNode()
        let leftEarPath = CGMutablePath()
        leftEarPath.move(to: CGPoint(x: -30, y: 20))
        leftEarPath.addLine(to: CGPoint(x: -15, y: 45))
        leftEarPath.addLine(to: CGPoint(x: -5, y: 20))
        leftEarPath.closeSubpath()
        leftEar.path = leftEarPath
        leftEar.fillColor = .init(white: 0.1, alpha: 1)
        leftEar.strokeColor = .darkGray
        
        // Right ear
        let rightEar = SKShapeNode()
        let rightEarPath = CGMutablePath()
        rightEarPath.move(to: CGPoint(x: 30, y: 20))
        rightEarPath.addLine(to: CGPoint(x: 15, y: 45))
        rightEarPath.addLine(to: CGPoint(x: 5, y: 20))
        rightEarPath.closeSubpath()
        rightEar.path = rightEarPath
        rightEar.fillColor = .init(white: 0.1, alpha: 1)
        rightEar.strokeColor = .darkGray
        
        umbra.addChild(body)
        umbra.addChild(leftEye)
        umbra.addChild(rightEye)
        umbra.addChild(leftEar)
        umbra.addChild(rightEar)
        
        umbra.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(umbra)
    }
}
