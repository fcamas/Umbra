//
//  AbilityButton.swift
//  Umbra
//
//  Created by Fredy C on 2/9/25.
//


import SpriteKit

class AbilityButton: SKNode {
    
    let circle: SKShapeNode
    let icon: SKLabelNode
    let cooldownRing: SKShapeNode
    var isUnlocked = false
    var isOnCooldown = false
    let radius: CGFloat
    
    init(radius: CGFloat, iconText: String, color: UIColor) {
        self.radius = radius
        
        // Outer ring
        circle = SKShapeNode(circleOfRadius: radius)
        circle.fillColor = UIColor(white: 0.1, alpha: 0.7)
        circle.strokeColor = color.withAlphaComponent(0.3)
        circle.lineWidth = 2
        
        // Icon
        icon = SKLabelNode(text: iconText)
        icon.fontSize = radius * 0.7
        icon.verticalAlignmentMode = .center
        icon.alpha = 0.3
        
        // Cooldown ring overlay
        cooldownRing = SKShapeNode(circleOfRadius: radius - 2)
        cooldownRing.fillColor = UIColor(white: 0.0, alpha: 0.5)
        cooldownRing.strokeColor = .clear
        cooldownRing.alpha = 0
        
        super.init()
        
        addChild(circle)
        addChild(icon)
        addChild(cooldownRing)
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func unlock(color: UIColor) {
        isUnlocked = true
        circle.strokeColor = color
        circle.lineWidth = 2.5
        icon.alpha = 1.0
        
        // Pop animation
        let pop = SKAction.sequence([
            SKAction.scale(to: 1.3, duration: 0.15),
            SKAction.scale(to: 1.0, duration: 0.15)
        ])
        run(pop)
    }
    
    func triggerCooldown(duration: TimeInterval) {
        guard !isOnCooldown else { return }
        isOnCooldown = true
        cooldownRing.alpha = 1.0
        
        let fade = SKAction.fadeOut(withDuration: duration)
        let reset = SKAction.run { self.isOnCooldown = false }
        cooldownRing.run(SKAction.sequence([fade, reset]))
    }
}
