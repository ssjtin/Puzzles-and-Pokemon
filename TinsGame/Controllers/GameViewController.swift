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
    
    var scene: BattleScene?
    var isAnimating: Bool = false

    var encounter: Encounter!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let path = Bundle.main.url(forResource: "map", withExtension: "json")
//        do {
//            let jsonData = try Data(contentsOf: path!)
//            let decoder = JSONDecoder()
//            let object = try decoder.decode(Map.self, from: jsonData)
//            print(object)
//        } catch let error {
//            print(error)
//        }
//
        // Configure view
        skView = view as? SKView
        skView.isMultipleTouchEnabled = false

        //Load mapScene
        
        let scene = HomeTownScene(fileNamed: "HomeTownLayout")!
        scene.sceneDelegate = self

        skView.presentScene(scene)

    }
    
    func handleSwipe(_ swap: Swap) {
        
        scene?.level.performSwap(swap)
        scene?.animate(swap) { [unowned self] in
            guard let scene = self.scene else { return }
            scene.swipedOrbs.remove(at: 0)
            if scene.swipedOrbs.count > 1 {
                scene.trySwap()
            }
        }
    }
    
    func handleMatches() {
        
        func removeMatches(_ chains: Set<Chain>) {
            scene?.level.removeMatches(chains)
            scene?.animateMatchedOrbs(for: chains) {
                guard let columns = self.scene?.level.fillHoles() else { return }
                self.scene?.animateFallingOrbs(in: columns, completion: {
                    guard let columns = self.scene?.level.topUpOrbs() else { return }
                    self.scene?.animateNewOrbs(in: columns, completion: {
                        if let newChains = self.scene?.level.detectMatches() {
                            removeMatches(newChains)
                        } else {
                            self.scene?.resolveCombos()
                        }
                    })
                })
            }
        }
        
        if let chains = scene?.level.detectMatches() {
            removeMatches(chains)
        }
    
    }

}

extension GameViewController: GameSceneDelegate {
    
    func presentBattleScene() {
        // Configure battle scene
        scene = BattleScene(size: skView.bounds.size)
        scene?.scaleMode = .aspectFill
        scene?.sceneDelegate = self
        
        encounter = Encounter()
        scene?.encounter = encounter
        scene?.encounter.battleDelegate = scene
        scene?.configureEnemy()
        
        scene?.swipeHandler = handleSwipe
        scene?.resolveMatchesHandler = handleMatches
        
        let transition = SKTransition.crossFade(withDuration: 1)
        skView.presentScene(scene!, transition: transition)
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
