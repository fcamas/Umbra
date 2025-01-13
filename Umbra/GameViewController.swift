//
//  GameViewController.swift
//  Umbra
//
//  Created by Fredy C on 12/10/24.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        let scene = MenuScene(size: CGSize(width: 812, height: 375))
        scene.scaleMode = .aspectFill
        
        let skView = view as! SKView
        skView.presentScene(scene)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
