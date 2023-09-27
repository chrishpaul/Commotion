//
//  GameViewController.swift
//  Commotion
//
//  Created by Eric Larson on 9/6/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    lazy var scene:GameScene = {
        return GameScene(size: view.bounds.size)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup game scene
        let skView = view as! SKView // the view in storyboard must be an SKView
        skView.showsFPS = true // show some debugging of the FPS
        skView.showsNodeCount = true // show how many active objects are in the scene
        skView.ignoresSiblingOrder = true // don't track who entered scene first
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }

    
    // don't show the time and status bar at the top
    override var prefersStatusBarHidden : Bool {
        return true
    }
    

    @IBAction func moveRight(_ sender: Any) {
        self.scene.moveScoreNode(by: 10)
    }
    
    @IBAction func moveLeft(_ sender: Any) {
        self.scene.moveScoreNode(by: -10)
    }
}
