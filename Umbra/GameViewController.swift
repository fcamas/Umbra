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
        
        let screenSize = UIScreen.main.bounds.size
        let sceneSize = CGSize(
            width: max(screenSize.width, screenSize.height),
            height: min(screenSize.width, screenSize.height)
        )
        let scene = MenuScene(size: sceneSize)
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
