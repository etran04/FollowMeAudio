//
//  ItemsViewController.swift
//  FollowMe
//
//  Created by Eric Tran on 8/27/15.
//  Copyright (c) 2015 Harman International. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import MediaPlayer

struct ItemsViewControllerConstant {
    static let storedItemsKey = "storedItems"
}

struct MusicInfo {
    var defaultSong: Bool!
    var artist: String!
    var songName: String!
    var songPersistentID: MPMediaEntityPersistentID!
}

class ItemsViewController: UIViewController {

    @IBOutlet weak var itemsTableView: UITableView!
    
    var g_alert: UIAlertController!
    
    let locationManager = CLLocationManager()
    var HKWControl: HKWControlHandler!
    
    // Stores list of beacons
    var items: [Item] = []
    
    // Store speaker name to a beacon
    var nameToIndexes = [String: Item]()
    var currentItemNdx: Int!
    
    // Current playback variables
    var musicInfo: MusicInfo!
    var playFlag = false
    var stopFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        loadItems()
        
        if musicInfo == nil {
            musicInfo = MusicInfo()
            musicInfo.defaultSong = true;
            musicInfo.artist = "The Weeknd"
            musicInfo.songName = "The Hills"
            musicInfo.songPersistentID = 0;
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if !HKWControlHandler.sharedInstance().isInitialized() {
            // show the network initialization dialog
            self.g_alert = UIAlertController(title: "Initializing", message: "If this dialog does not disappear, please check if any other HK WirelessHD App is running on the phone and kill it. Or, your phone is not in a Wifi network.", preferredStyle: .Alert)
            
            self.presentViewController(self.g_alert, animated: true, completion: nil)
        }
        
        if !HKWControlHandler.sharedInstance().initializing() && !HKWControlHandler.sharedInstance().isInitialized() {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                if HKWControlHandler.sharedInstance().initializeHKWirelessController(kLicenseKeyGlobal, withSpeakersAdded:false) != 0 {
                    println("initializeHKWirelessControl failed : invalid license key")
                    return
                }
                println("InitializeHKWirelessControl - OK");
                
                self.HKWControl = HKWControlHandler.sharedInstance()
                self.HKWControl.setVolume(0)

                // dismiss the network initialization dialog
                if self.g_alert != nil {
                    self.g_alert.dismissViewControllerAnimated(true, completion: nil)
                }
                
            })
        }
        
        if playFlag {
            // Alerts the user  music is being played
            g_alert = UIAlertController(title: "Playback", message: "Song is currently being played", preferredStyle: .Alert)
            g_alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
                self.dismissViewControllerAnimated(false, completion: nil)
            }))
            self.presentViewController(g_alert, animated: false, completion: nil)
            playFlag = false
        }
        
        if stopFlag {
            // Alerts the user  music is being stopped
            g_alert = UIAlertController(title: "Stopped", message: "Song is stopped", preferredStyle: .Alert)
            g_alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
                self.dismissViewControllerAnimated(false, completion: nil)
            }))
            self.presentViewController(g_alert, animated: false, completion: nil)
            stopFlag = false
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
    /* Loads preloads beacon information from previous runs into table when app starts */
    func loadItems() {
        if let storedItems = NSUserDefaults.standardUserDefaults().arrayForKey(ItemsViewControllerConstant.storedItemsKey) {
            for itemData in storedItems {
                let item = NSKeyedUnarchiver.unarchiveObjectWithData(itemData as! NSData) as! Item
                items.append(item)
                startMonitoringItem(item)
            }
        }
    }
  
    /* Saves beacon information for later application runs */
    func persistItems() {
        var itemsDataArray:[NSData] = []
        for item in items {
            let itemData = NSKeyedArchiver.archivedDataWithRootObject(item)
            itemsDataArray.append(itemData)
        }
        NSUserDefaults.standardUserDefaults().setObject(itemsDataArray, forKey: ItemsViewControllerConstant.storedItemsKey)
    }
  
    func beaconRegionWithItem(item:Item) -> CLBeaconRegion {
        let beaconRegion = CLBeaconRegion(proximityUUID: item.uuid, major: item.majorValue, minor: item.minorValue, identifier: item.name)
        return beaconRegion
    }
  
    func startMonitoringItem(item:Item) {
        let beaconRegion = beaconRegionWithItem(item)
        locationManager.startMonitoringForRegion(beaconRegion)
        locationManager.startRangingBeaconsInRegion(beaconRegion)
    }
  
    func stopMonitoringItem(item:Item) {
        let beaconRegion = beaconRegionWithItem(item)
        locationManager.stopMonitoringForRegion(beaconRegion)
        locationManager.stopRangingBeaconsInRegion(beaconRegion)
    }
  
    // MARK: Unwind Segue actions
    
    // Called when a user clicks to save a beacon to the list
    @IBAction func saveItem(segue: UIStoryboardSegue) {
        let addItemViewController = segue.sourceViewController as! AddItemViewController
        if let newItem = addItemViewController.newItem {
            items.append(newItem)
            itemsTableView.beginUpdates()
            let newIndexPath = NSIndexPath(forRow: items.count-1, inSection: 0)
            itemsTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
            itemsTableView.endUpdates()
            startMonitoringItem(newItem)
            searchBeacons(newItem)
            persistItems()
        }
    }
    
    // Called when the user selects 'Play Song' on SettingsVC
    @IBAction func playSong(segue: UIStoryboardSegue) {
        let songVC = segue.sourceViewController as! SettingsVC
        if let newSong = songVC.musicInfo {
            musicInfo = newSong
        }
        startPlayback()
    }
    
    // Called when a user is clicks on a speaker to pair the beacon
    @IBAction func savePairedSpeaker(segue: UIStoryboardSegue) {
        let speakerVC = segue.sourceViewController as! SpeakerSelectionTableViewController
        if (speakerVC.speakerName != nil) {
            println("MainVC: Paired speaker name is \(speakerVC.speakerName)")
            items[currentItemNdx].setSpeakerPairName(speakerVC.speakerName)
            clearUnpairedSpeakers()
            persistItems()
            
            // update table 
            self.itemsTableView.beginUpdates()
            self.itemsTableView.reloadData()
            self.itemsTableView.endUpdates()
        }
    }
  
    @IBAction func cancelItem(segue: UIStoryboardSegue) {
        // Do nothing
    }
    
    // MARK: Follow Me Audio Functionality
    
    /* Goes through list of speakers and assigns index number to speaker if a match name occurs
     * If current speaker does not match, removes that speaker from playback session.
     */
    func searchBeacons(item: Item) {
        for (var i = 0; i < HKWControl?.getDeviceCount(); i++) {
            var dInfo = HKWControl.getDeviceInfoByIndex(i)
            if dInfo.deviceName == item.speakerPair && nameToIndexes[dInfo.deviceName] == nil {
                println("DeviceName: \(dInfo.deviceName) | BeaconName: \(item.name)");
                println("Assigning speaker: \(dInfo.deviceName) w/ \(i)...")
                item.setIndex(i)
                nameToIndexes[dInfo.deviceName] = item
                HKWControl.addDeviceToSession(dInfo.deviceId)
            }
        }
    }
    
    /* Helper method for removing all inactive beacon speaker pairs from session */
    func clearUnpairedSpeakers() {
        if items.count == 0 {
            println("Removed all speakers from session")
            for (var i = 0; i < HKWControl?.getDeviceCount(); i++) {
                var dInfo = HKWControl.getDeviceInfoByIndex(i)
                HKWControl.removeDeviceFromSession(dInfo.deviceId)
                nameToIndexes.removeValueForKey(dInfo.deviceName)
            }
        }
        else {
            for (var i = 0; i < HKWControl?.getDeviceCount(); i++) {
                var dInfo = HKWControl.getDeviceInfoByIndex(i)
                for (var j = 0; j < items.count; j++) {
                    var bInfo = items[j]
                    if dInfo.deviceName != bInfo.speakerPair && dInfo.active{
                        HKWControl.removeDeviceFromSession(dInfo.deviceId)
                        nameToIndexes.removeValueForKey(dInfo.deviceName)
                        println("Removing speaker: \(dInfo.deviceName) from session...")
                    }
                }
            }
        }
    }
    
    /* Helper method for determining which speaker - beacon is interacting and acts accordingly */
    func checkBeaconAndAdjust(beacon:CLBeacon, index: Int) {
        var currentDevice = HKWControl.getDeviceInfoByIndex(index)
        // If the beacon is 'Near' or 'Immediate'(ly) close, play music on that speaker and adjust the volume if we move around.
        if beacon.proximity == CLProximity.Immediate || beacon.proximity == CLProximity.Near {
            var volumeLvl = changeVolumeBasedOnRange(beacon)
            HKWControl.setVolumeDevice(currentDevice.deviceId, volume: volumeLvl)
            
            // Debugging print to check which speaker is playing
            // println("Beacon major: \(beacon.major.intValue) | minor: \(beacon.minor.intValue) | volume: \(volumeLvl) | rssi: \(beacon.rssi)");
    
            // Uncomment if you want app to start playing automatically when in range of beacons
            //
            // if !self.HKWControl.isPlaying() {
            //    playStreamingWithPersistentID(false, 0)
            // }
            
        }
        // If beacon is 'Far' or 'Unknown' (out of reach), turn down the volume of that speaker to 0
        else {
            // This condition allows for fading out...
            if currentDevice.volume >= 3 {
                HKWControl.setVolumeDevice(currentDevice.deviceId, volume: currentDevice.volume - 3)
            }
            else {
                HKWControl.setVolumeDevice(currentDevice.deviceId, volume: currentDevice.volume - 0)

            }
        }
    
    }
    
    /* Starts the playing of the first mp3 file embedded into project, or a provided persistent id */
    func playStreamingWithPersistentID(playDefault: Bool, persistentId: MPMediaEntityPersistentID ) {
        // Default song
        if playDefault {
            var bundleRoot = NSBundle.mainBundle().bundlePath
            var dirContents: NSArray = NSFileManager.defaultManager().contentsOfDirectoryAtPath(bundleRoot, error: nil)!
            var fltr: NSPredicate = NSPredicate(format: "self ENDSWITH '.mp3'")
            var g_mp3Files = dirContents.filteredArrayUsingPredicate(fltr) as! [String]
    
            var assetURL = NSURL.fileURLWithPath(bundleRoot.stringByAppendingPathComponent(g_mp3Files[0]))
            println("NSURL: \(assetURL)")
    
            HKWControl.playCAF(assetURL, songName:g_mp3Files[0], resumeFlag:true);
        }
        // Chosen song
        else {
            let query = MPMediaQuery.songsQuery()
            let predicate = MPMediaPropertyPredicate(value: String(persistentId), forProperty: MPMediaItemPropertyPersistentID)
            query.addFilterPredicate(predicate)
            
            let item = query.items.first as! MPMediaItem
            var assetURL = item.assetURL
            HKWControl.playCAF(assetURL, songName: item.title, resumeFlag: false)
            
            println("Playing \(item.title) from library")
        }
        playFlag = true;
    }
    
    /* Helper method for quick playback and stopping of current played track */
    func startPlayback() {
        if HKWControl.isPlaying() {
            HKWControl.stop()
            stopFlag = true
            println("Stopped playing...")
        }
        else {
            playStreamingWithPersistentID(musicInfo.defaultSong, persistentId: musicInfo.songPersistentID)
            println("Started playing...")
        }
    }
    
    /* Used to determine the volume of the associated beacon to speaker. */
    func changeVolumeBasedOnRange(beacon: CLBeacon) -> Int {
        var volume = 0;
        
        switch (beacon.proximity) {
        case CLProximity.Far:
            break;
        case CLProximity.Near:
            volume = 15
            break;
        case CLProximity.Immediate:
            volume = 10 
            break;
        case CLProximity.Unknown:
            break;
        default:
            break;
        }
        
        return volume;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let segueName = segue.identifier
        // Passes the current song info to the settings VC to display
        if segueName == "goToSettingsVC" {
            var destVC: SettingsVC = segue.destinationViewController as! SettingsVC
            destVC.musicInfo = musicInfo
        }
    }
}

// MARK: UITableViewDataSource
extension ItemsViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
  
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Item", forIndexPath: indexPath) as! ItemCell
        let item = items[indexPath.row]
        cell.item = item
        return cell
    }
  
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
  
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let itemToRemove = items[indexPath.row] as Item
            stopMonitoringItem(itemToRemove)
            tableView.beginUpdates()
            items.removeAtIndex(indexPath.row)
            clearUnpairedSpeakers()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            tableView.endUpdates()
            persistItems()
        }
    }
}

// MARK: UITableViewDelegate
extension ItemsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let item = items[indexPath.row] as Item
        let uuid = item.uuid.UUIDString
        let detailMessage = "UUID: \(uuid)\nMajor: \(item.majorValue)\nMinor: \(item.minorValue)\nPaired w/: \(item.speakerPair)"
        let detailAlert = UIAlertController(title: "Details", message: detailMessage, preferredStyle: .Alert)
        detailAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        detailAlert.addAction(UIAlertAction(title: "Pair speaker", style: .Default, handler: { action in
            println("Showing pair speaker screen...")
            self.currentItemNdx = indexPath.row
            self.performSegueWithIdentifier("pairSpeakersSegue", sender: self)
        }))

        self.presentViewController(detailAlert, animated: true, completion: nil)
    }
}

// MARK: CLLocationManagerDelegate
extension ItemsViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager!, monitoringDidFailForRegion region: CLRegion!, withError error: NSError!) {
        println("Failed monitoring region: \(error.description)")
    }
  
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Location manager failed: \(error.description)")
    }
  
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        if let beacons = beacons as? [CLBeacon] {
            for beacon in beacons {
                for item in items {
                    
                    // Assign speaker indexes to beacons if neccesary
                    searchBeacons(item)
                    
                    if item == beacon {
                        
                        // Assign speaker indexes to beacons if neccesary
                        item.lastSeenBeacon = beacon
                        
                        // There is an associated beacon to speaker pair
                        var speakerNdx = nameToIndexes[item.speakerPair]?.speakerNdx;
                        if speakerNdx != nil {
                            checkBeaconAndAdjust(beacon, index: speakerNdx!)
                        }
                    }
                }
            }
        }
    }
}

// MARK: HKWDeviceHandlerDelegate
extension ItemsViewController: HKWPlayerEventHandlerDelegate {
    func hkwPlayEnded() {
        if g_alert != nil {
            g_alert.dismissViewControllerAnimated(false, completion: nil)
            playFlag = false
            stopFlag = false
        }
    }
}



