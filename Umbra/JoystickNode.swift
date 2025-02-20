//
//  JoystickNode.swift
//  Umbra
//
//  Created by Fredy C on 2/2/25.
//


import SpriteKit

class JoystickNode: SKNode {
    
    let base: SKShapeNode
    let thumb: SKShapeNode
    let baseRadius: CGFloat = 50
    let thumbRadius: CGFloat = 22
    
    var onMove: ((CGFloat) -> Void)?
    var onJump: (() -> Void)?
    
    private var touchID: UITouch?
    
    override init() {
        base = SKShapeNode(circleOfRadius: 50)
        base.fillColor = UIColor(white: 1.0, alpha: 0.08)
        base.strokeColor = UIColor(white: 1.0, alpha: 0.25)
        base.lineWidth = 1.5
        base.zPosition = 10
        
        thumb = SKShapeNode(circleOfRadius: 22)
        thumb.fillColor = UIColor(white: 1.0, alpha: 0.25)
        thumb.strokeColor = UIColor(white: 1.0, alpha: 0.5)
        thumb.lineWidth = 1.5
        thumb.zPosition = 11
        
        super.init()
        
        addChild(base)
        addChild(thumb)
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touchID == nil, let touch = touches.first else { return }
        touchID = touch
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first(where: { $0 === touchID }),
              let parent = parent else { return }
        
        let loc = touch.location(in: parent)
        let base_pos = position
        let delta = CGPoint(x: loc.x - base_pos.x, y: loc.y - base_pos.y)
        let distance = sqrt(delta.x * delta.x + delta.y * delta.y)
        let maxDist = baseRadius - thumbRadius
        
        if distance < maxDist {
            thumb.position = delta
        } else {
            let angle = atan2(delta.y, delta.x)
            thumb.position = CGPoint(x: cos(angle) * maxDist, y: sin(angle) * maxDist)
        }
        
        // Send horizontal movement — normalized -1 to 1
        let normalized = thumb.position.x / maxDist
        onMove?(normalized)
        
        // Jump if pushed up strongly
        if thumb.position.y > maxDist * 0.6 {
            onJump?()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.first(where: { $0 === touchID }) != nil else { return }
        touchID = nil
        thumb.position = .zero
        onMove?(0)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
}
