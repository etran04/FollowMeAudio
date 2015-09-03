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
  
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if let anItem = object as? Item {
            if anItem == item && keyPath == "lastSeenBeacon" {
                let proximity = nameForProximity(anItem.lastSeenBeacon!.proximity)
                let accuracy = NSString(format: "%.2f", anItem.lastSeenBeacon!.accuracy)
                let rssi = anItem.lastSeenBeacon!.rssi
                let pairName = anItem.speakerPair
                detailTextLabel!.text = "Location: \(proximity) || RSII: \(rssi) || Paired w/: \(pairName)"
            }
            else {
                detailTextLabel!.text = "Location: Cannot be determined"
            }
        }
    }
}
