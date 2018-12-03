//
//  OptionsScene.swift
//  Feed Me
//
//  Created by Bartosz Osowski on 03/12/2018.
//  Copyright © 2018 Bartosz Osowski. All rights reserved.
//

import Foundation
import SpriteKit

class OptionsScene: SKScene{
    
    var backButton: SKSpriteNode!
    var cutMultipleVinesButton: SKSpriteNode!
    
    var label: SKLabelNode!
    static var CanCutMultipleVinesAtOnce = false
    
    override func didMove(to view: SKView){
        backButton = (self.childNode(withName: "back_button") as! SKSpriteNode)
        cutMultipleVinesButton = (self.childNode(withName: "cut_multiple_vines_button") as! SKSpriteNode)
        label = cutMultipleVinesButton.childNode(withName: "SKLabelNode") as? SKLabelNode
        label.text = "Cut multiple vines: \(OptionsScene.CanCutMultipleVinesAtOnce ? "ON" : "OFF")"
        playMusic()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        let touch = touches.first

        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)

            if nodesArray.contains(cutMultipleVinesButton){
                OptionsScene.CanCutMultipleVinesAtOnce = !OptionsScene.CanCutMultipleVinesAtOnce
                label.text = "Cut multiple vines: \(OptionsScene.CanCutMultipleVinesAtOnce ? "ON" : "OFF")"
            }
            else if nodesArray.contains(backButton){
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let menuScene = MenuScene(fileNamed: "MenuScene")
                menuScene!.scaleMode = .aspectFill
                self.view?.presentScene(menuScene!, transition: transition)
            }
        }
    }
}
