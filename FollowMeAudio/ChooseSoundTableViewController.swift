//
//  ChooseSoundTableViewController.swift
//  HKRules
//
//  Created by Tyler Freckmann on 8/5/15.
//  Copyright (c) 2015 Tyler Freckmann. All rights reserved.
//

import UIKit
import MediaPlayer

class ChooseSoundTableViewController: UITableViewController, MPMediaPickerControllerDelegate {
    
    var musicInfo: MusicInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        musicInfo = MusicInfo()
        musicInfo.defaultSong = true
        musicInfo.artist = "The Weeknd"
        musicInfo.songName = "The Hills"
        musicInfo.songPersistentID = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 2
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var optionalCell: AnyObject? = tableView.dequeueReusableCellWithIdentifier("cell")
        var cell: UITableViewCell
        if optionalCell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        } else {
            cell = optionalCell as! UITableViewCell
        }
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Default song"
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            cell.selectionStyle = UITableViewCellSelectionStyle.None

        default:
            cell.textLabel?.text = "Song from library"
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.selectionStyle = UITableViewCellSelectionStyle.None

        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell?.accessoryType == UITableViewCellAccessoryType.None {
            var defaultCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
            var soundCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0))
            
            // If song cell is checked
            if defaultCell?.accessoryType == UITableViewCellAccessoryType.Checkmark {
                defaultCell?.accessoryType = UITableViewCellAccessoryType.None
                soundCell?.accessoryType = UITableViewCellAccessoryType.Checkmark
                // Get song
                getSong()
            } else {
                defaultCell?.accessoryType = UITableViewCellAccessoryType.Checkmark
                soundCell?.accessoryType = UITableViewCellAccessoryType.None
            }
        }
    }
    
    func getSong() {
        let picker = MPMediaPickerController(mediaTypes: MPMediaType.Music)
        picker.delegate = self
        picker.allowsPickingMultipleItems = false
        picker.prompt = "Choose song"
        picker.showsCloudItems = false
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func mediaPicker(mediaPicker: MPMediaPickerController!, didPickMediaItems mediaItemCollection: MPMediaItemCollection!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        let mediaItem = mediaItemCollection.items[0] as! MPMediaItem
        musicInfo.defaultSong = false;
        musicInfo.artist = mediaItem.artist
        musicInfo.songName = mediaItem.title
        musicInfo.songPersistentID = mediaItem.persistentID
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "saveSong" {
            let destVC = segue.destinationViewController as! ItemsViewController
            destVC.musicInfo = musicInfo
            println("in save song")
        }
    }*/


}
