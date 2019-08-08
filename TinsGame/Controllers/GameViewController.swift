//
//  GameViewController.swift
//  TinsGame
//
//  Created by Hoang Luong on 21/7/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

protocol GameSceneDelegate: class {
    func presentBattleScene()
    func removeBattleScene(on view: SKView)
    func transition(to sceneName: String, from view: SKView?)
}

extension GameSceneDelegate {
    
    func scene(for sceneName: String) -> BaseScene? {
        if sceneName.contains("MapScene") {
            return HomeTownScene(fileNamed: "HomeTownLayout")
        }
        
        if sceneName.contains("house") {
            return HouseScene(fileNamed: "HouseSceneLayout")
        }
        
        if sceneName == "ViridianForest" {
            return ViridianForestScene(fileNamed: "ViridianForestLayout")
        }
        
        return nil
    }
    
}

class GameViewController: UIViewController {
    
    weak var skView: SKView!

    override func viewDidLoad() {
        super.viewDidLoad()

        skView = self.view as? SKView
        
        let scene = HomeTownScene(fileNamed: "HomeTownLayout")!
        scene.sceneDelegate = self

        skView.presentScene(scene)

    }

}

extension GameViewController: GameSceneDelegate {
    
    func presentBattleScene() {
        // Configure battle scene
        let scene = BattleScene(size: skView.frame.size)
        scene.sceneDelegate = self
        let transition = SKTransition.crossFade(withDuration: 1)

        skView.presentScene(scene, transition: transition)
    }
    
    func removeBattleScene(on view: SKView) {
        let scene = HomeTownScene(fileNamed: "HomeTownLayout")!
        scene.sceneDelegate = self
        let transition = SKTransition.fade(withDuration: 1)
        view.presentScene(scene, transition: transition)
    }
    
    func transition(to sceneName: String, from view: SKView?) {
        if let newScene = scene(for: sceneName) {
            newScene.sceneDelegate = self
            let transition = SKTransition.crossFade(withDuration: 1)
            view?.presentScene(newScene, transition: transition)
        }
        
    }
    
}
