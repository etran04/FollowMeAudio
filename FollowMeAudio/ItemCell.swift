//
//  ItemCell.swift
//  FollowMe
//
//  Created by Eric Tran on 8/27/15.
//  Copyright (c) 2015 Harman International. All rights reserved.
//

import UIKit
import CoreLocation

class ItemCell: UITableViewCell {
    @IBOutlet weak var valueTextView: UITextView!
  
    var item: Item? = nil {
        willSet {
            if let thisItem = item {
                thisItem.removeObserver(self, forKeyPath: "lastSeenBeacon")
            }
        }
        didSet {
            item?.addObserver(self, forKeyPath: "lastSeenBeacon", options: .New, context: nil)
      
            textLabel!.text = item?.name
            if (item != nil && item!.speakerPair != nil) {
                detailTextLabel!.text = "Location: Unknown || RSII: 0 || Paired w/: \(item!.speakerPair)"
            }
            else {
                detailTextLabel!.text = "Location: Unknown || RSII: 0 || Paired w/: N/A"
                
            }
        }
    }
  
    deinit {
        item?.removeObserver(self, forKeyPath: "lastSeenBeacon")
    }
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }
  
    override func prepareForReuse() {
        super.prepareForReuse()
        item = nil
        detailTextLabel!.text = "Location: Unknown" 
    }
  
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  
    func nameForProximity(proximity: CLProximity) -> String {
        switch proximity {
        case .Unknown:
            return "Unknown"
        case .Immediate:
            return "Immediate"
        case .Near:
            return "Near"
        case .Far:
            return "Far"
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if let anItem = object as? Item {
            if anItem == item && keyPath == "lastSeenBeacon" {
                let proximity = nameForProximity(anItem.lastSeenBeacon!.proximity)
                _ = NSString(format: "%.2f", anItem.lastSeenBeacon!.accuracy)
                let rssi = anItem.lastSeenBeacon!.rssi
                let pairName = anItem.speakerPair
                detailTextLabel!.text = "Location: \(proximity) || RSII: \(rssi) || Paired w/: \(pairName)"
            }
        }
        
    }
  
//    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
//        if let anItem = object as? Item {
//            if anItem == item && keyPath == "lastSeenBeacon" {
//                let proximity = nameForProximity(anItem.lastSeenBeacon!.proximity)
//                _ = NSString(format: "%.2f", anItem.lastSeenBeacon!.accuracy)
//                let rssi = anItem.lastSeenBeacon!.rssi
//                let pairName = anItem.speakerPair
//                detailTextLabel!.text = "Location: \(proximity) || RSII: \(rssi) || Paired w/: \(pairName)"
//            }
//        }
//    }
        
}
