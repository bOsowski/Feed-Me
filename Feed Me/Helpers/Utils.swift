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
