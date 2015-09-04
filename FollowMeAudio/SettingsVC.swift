//
//  SettingsVC.swift
//  FollowMe
//
//  Created by Eric Tan on 9/1/15.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit
import Foundation

class SettingsVC: UIViewController {

    var musicInfo: MusicInfo!

    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        volumeLabel.text = "Volume offset: " + String(volumeOffset)
        if musicInfo != nil {
            artistName.text = musicInfo.artist
            songNameLabel.text = musicInfo.songName
        }
        else{
            artistName.text = "The Weeknd"
            songNameLabel.text = "The Hills"
        }
    }
    
    @IBAction func volumeUpPressed(sender: UIButton) {
        if volumeOffset < 30 {
            volumeOffset += 3
            volumeLabel.text = "Volume offset: " + String(volumeOffset)
            println("VolumeOffset: \(volumeOffset)")
        }
    }
    
    @IBAction func volumeDownPressed(sender: UIButton) {
        if volumeOffset > 0 {
            volumeOffset -= 3
            volumeLabel.text = "Volume offset: " + String(volumeOffset)
            println("VolumeOffset: \(volumeOffset)")
        }
    }
}
