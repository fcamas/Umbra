//
//  GameViewController.swift
//  Umbra
//
//  Created by Cat on 12/10/24.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = MenuScene(size: view.bounds.size)
        scene.scaleMode = .resizeFill
        
        let skView = view as! SKView
        skView.presentScene(scene)
    }
}
