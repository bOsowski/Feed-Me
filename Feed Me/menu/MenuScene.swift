//
//  MenuScene.swift
//  Feed Me
//
//  Created by Bartosz Osowski on 30/11/2018.
//  Copyright © 2018 Bartosz Osowski. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene : SKScene{
    
    var newGameButton:SKSpriteNode!
    var optionsButton:SKSpriteNode!
    
    override func didMove(to view: SKView){
        newGameButton = (self.childNode(withName: "new_game_button") as! SKSpriteNode)
        optionsButton = (self.childNode(withName: "options_button") as! SKSpriteNode)
        playMusic()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        let touch = touches.first
        
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            let transition = SKTransition.flipHorizontal(withDuration: 0.5)

            if nodesArray.contains(newGameButton){
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene, transition: transition)
            }
            else if nodesArray.contains(optionsButton){
                let optionsScene = OptionsScene(fileNamed: "OptionsScene")
                optionsScene!.scaleMode = .aspectFill
                self.view?.presentScene(optionsScene!, transition: transition)
            }
        }
    }
}
