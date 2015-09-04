//
//  SpeakerSelectionTableViewController.swift
//  HKRules
//
//  Created by Seonman Kim on 8/20/15.
//  Copyright (c) 2015 Tyler Freckmann. All rights reserved.
//

import UIKit

class SpeakerSelectionTableViewController: UITableViewController, HKWDeviceEventHandlerDelegate {
    
    var speakerName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HKWDeviceEventHandlerSingleton.sharedInstance().delegate = self
        HKWControlHandler.sharedInstance().startRefreshDeviceInfo()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        HKWControlHandler.sharedInstance().stopRefreshDeviceInfo()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return HKWControlHandler.sharedInstance().getGroupCount()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HKWControlHandler.sharedInstance().getDeviceCountInGroupIndex(section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Speaker_Cell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        var deviceInfo: DeviceInfo = HKWControlHandler.sharedInstance().getDeviceInfoByGroupIndexAndDeviceIndex(indexPath.section, deviceIndex: indexPath.row)
        
        cell.textLabel?.text = deviceInfo.deviceName;
        var uniqueId: NSString = NSString(format: "ID:%llu, Vol:%d", deviceInfo.deviceId, deviceInfo.volume)
        cell.detailTextLabel?.text = uniqueId as String
        
        // Show the checkmark if the speaker is active
        if deviceInfo.active {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var header = HKWControlHandler.sharedInstance().getDeviceGroupNameByIndex(section);
        return header
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("Speaker_Cell", forIndexPath: indexPath) as! UITableViewCell
        var deviceInfo: DeviceInfo = HKWControlHandler.sharedInstance().getDeviceInfoByGroupIndexAndDeviceIndex(indexPath.section, deviceIndex: indexPath.row)
        
        if !deviceInfo.active {
            // Choosing an unpaired speaker
            println("SpeakerSelectVC: Choosing an unpaired speaker...")
            speakerName = deviceInfo.deviceName
            println("SpeakerSelectVC: Pairing with speaker: \(deviceInfo.deviceName)")
            HKWControlHandler.sharedInstance().addDeviceToSession(deviceInfo.deviceId)
            self.performSegueWithIdentifier("finishPairWithSpeaker", sender: self)
        }
    }
    
    func hkwDeviceStateUpdated(deviceId: Int64, withReason reason: Int) {
        self.tableView.reloadData()
        
    }
    
    func hkwErrorOccurred(errorCode: Int, withErrorMessage errorMesg: String!) {
        println("Error: \(errorMesg)")
    }
}
