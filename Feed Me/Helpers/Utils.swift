//
//  Utils.swift
//  Feed Me
//
//  Created by Bartosz Osowski on 01/12/2018.
//  Copyright © 2018 Bartosz Osowski. All rights reserved.
//

import Foundation
import AVFoundation

public var backgroundMusicPlayer: AVAudioPlayer!

var counter:Int = 0

func playMusic(){
    if backgroundMusicPlayer == nil {
        let backgroundMusicURL = Bundle.main.url(forResource: SoundFile.BackgroundMusic, withExtension: nil)
        
        do {
            let theme = try AVAudioPlayer(contentsOf: backgroundMusicURL!)
            backgroundMusicPlayer = theme
            
            if !backgroundMusicPlayer.isPlaying {
                backgroundMusicPlayer.play()
            }
        } catch {
            // couldn't load file :[
        }
        
        backgroundMusicPlayer.numberOfLoops = -1
    }
}

func generateRandomLevel() -> [VineNode]{
    let lines = [Line(pt1: CGPoint(x: 65.199, y: 1334), pt2: CGPoint(x: 183.198, y: 667)), Line(pt1: CGPoint(x: 663.731, y: 1334), pt2: CGPoint(x: 618.97, y: 695.51))]
    
    //I could use
    let minLength = 15
    let maxLength = 25
    
    var vines:[VineNode] = []
    
    func addVine(line: Line){
        vines.append(VineNode(length: Int.random(in: minLength...maxLength), anchorPoint: line.getRandomPointOnLineBetweenPoints(), name: "\(counter)"))
        counter += 1
    }
    
    for _ in 1...Int.random(in: 1...3) {
        addVine(line: lines[Int.random(in: 0..<lines.count)])
    }

    return vines
}

private class Line{
    var slope: Double
    var c: Double
    var pt1: CGPoint
    var pt2: CGPoint
    
    init(pt1: CGPoint, pt2: CGPoint){
        self.pt1 = pt1
        self.pt2 = pt2
        slope = Double((pt2.y - pt1.y) / (pt2.x - pt1.x))
        c = (-slope * Double(pt1.x)) + Double(pt1.y)
    }
    
    func getRandomPointOnLineBetweenPoints() -> CGPoint{
        let lowerY = pt1.y < pt2.y ? pt1.y : pt2.y
        let higherY = pt1.y == lowerY ? pt2.y : pt1.y
        let y = Double(CGFloat.random(in: lowerY...higherY))
        let x = (y-c)/slope
        return CGPoint(x: x, y: y)
    }
}
