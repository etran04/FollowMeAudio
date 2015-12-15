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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if musicInfo != nil {
            artistName.text = musicInfo.artist
            songNameLabel.text = musicInfo.songName
        }
        else{
            artistName.text = "The Weeknd"
            songNameLabel.text = "The Hills"
        }
    }
    
    @IBAction func saveSong(segue: UIStoryboardSegue) {
        let songVC = segue.sourceViewController as! ChooseSoundTableViewController
        if let newSong = songVC.musicInfo {
            musicInfo = newSong
            print("SettingsVC.saveSong: Play default song? \(musicInfo.defaultSong)")
        }
    }
}
