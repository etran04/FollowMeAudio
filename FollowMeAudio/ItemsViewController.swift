import UIKit
import Foundation
import CoreLocation

struct ItemsViewControllerConstant {
    static let storedItemsKey = "storedItems"
}

// Time to average before first playback
let kSecondsToStart = 2

// Amount of seconds to gather data for
let kSecondsToPollFor = 5

// SuperOmni and SmartThing's beacon majors
let kSuperOmniMajor = 1010
let kSmartThingsMajor = 1100

// White Box beacon major
let kWhiteBoxMajor = 1001

// Seonman's beacons major values
let kEstimoteOneMinor = 60040 // super
let kEstimoteTwoMinor = 7710  // smart

class ItemsViewController: UIViewController {

    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var itemsTableView: UITableView!
  
    let locationManager = CLLocationManager()
    var HKWControl: HKWControlHandler!
    var items: [Item] = []
    var g_mp3Files = [String]()
    var superOmniNdx: Int = -1
    var smartThingsNdx: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        loadItems()
    }
    
    override func viewDidAppear(animated: Bool) {
        var g_alert: UIAlertController!
        
        if !HKWControlHandler.sharedInstance().isInitialized() {
            // show the network initialization dialog
            g_alert = UIAlertController(title: "Initializing", message: "If this dialog does not disappear, please check if any other HK WirelessHD App is running on the phone and kill it. Or, your phone is not in a Wifi network.", preferredStyle: .Alert)
            
            self.presentViewController(g_alert, animated: true, completion: nil)
        }
        
        if !HKWControlHandler.sharedInstance().initializing() && !HKWControlHandler.sharedInstance().isInitialized() {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                if HKWControlHandler.sharedInstance().initializeHKWirelessController(kLicenseKeyGlobal, withSpeakersAdded:true) != 0 {
                    println("initializeHKWirelessControl failed : invalid license key")
                    return
                }
                println("initializeHKWirelessControl - OK");
                
                self.HKWControl = HKWControlHandler.sharedInstance()

                // dismiss the network initialization dialog
                if g_alert != nil {
                    g_alert.dismissViewControllerAnimated(true, completion: nil)
                }
                
            })
        }
    }
    
    @IBAction func stopPressed(sender: UIButton) {
        if self.HKWControl.isPlaying() {
            self.HKWControl.stop()
            println("Stopped playing...")
        }
        else {
            self.playStreaming()
            println("Started playing")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
    func loadItems() {
        if let storedItems = NSUserDefaults.standardUserDefaults().arrayForKey(ItemsViewControllerConstant.storedItemsKey) {
            for itemData in storedItems {
                let item = NSKeyedUnarchiver.unarchiveObjectWithData(itemData as! NSData) as! Item
                items.append(item)
                startMonitoringItem(item)
            }
        }
    }
  
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
    @IBAction func saveItem(segue: UIStoryboardSegue) {
        let addItemViewController = segue.sourceViewController as! AddItemViewController
        if let newItem = addItemViewController.newItem {
            items.append(newItem)
            itemsTableView.beginUpdates()
            let newIndexPath = NSIndexPath(forRow: items.count-1, inSection: 0)
            itemsTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
            itemsTableView.endUpdates()
            startMonitoringItem(newItem)
            persistItems()
        }
    }
  
    @IBAction func cancelItem(segue: UIStoryboardSegue) {
        // Do nothing
    }
    
    // MARK: Follow Me Audio Functionality
    
    /* Goes through list of speakers and assigns index number to the superOmni and the smartThings speaker
     * If current speaker is neither, removes that speaker from playback session.
     * Currently hardcoded to look for speakers named "SuperOmni" and "SmartThings"
     */
    func searchBeacons() {
        for (var i = 0; i < self.HKWControl.getDeviceCount(); i++) {
            var dInfo = self.HKWControl.getDeviceInfoByIndex(i)
            if dInfo.deviceName == "SuperOmni" {
                self.superOmniNdx = i
            }
            else if dInfo.deviceName == "SmartThings" {
                self.smartThingsNdx = i
            }
            else {
                self.HKWControl.removeDeviceFromSession(dInfo.deviceId)
            }
        }
    }
    
    /* Helper method for determining which speaker - beacon is interacting and acts accordingly */
    func checkBeacon(beacon:CLBeacon, index: Int, rssi: Float) {
    
        // If the beacon is 'Near' or 'Immediate'(ly) close, play music on that speaker and adjust the volume if we move around.
        if (beacon.proximity == CLProximity.Near || beacon.proximity == CLProximity.Immediate) {
            var volumeLvl = self.changeVolumeBasedOnRange(beacon)
            println("... Beacon with major: \(beacon.major.intValue) | minor: \(beacon.minor.intValue) at volume: \(volumeLvl)");
            //int volumeLvl = [self changeVolumeBasedOnRSSI:rssi];
            self.HKWControl.setVolumeDevice(self.HKWControl.getDeviceInfoByIndex(index).deviceId, volume: volumeLvl)
    
            // If song isn't playing start playing it
            if !self.HKWControl.isPlaying() {
            //    self.playStreaming()
            }
        }
        // If beacon is 'Far' or 'Unknown' (out of reach), turn down the volume of that speaker to 0
        else {
            self.HKWControl.setVolumeDevice(self.HKWControl.getDeviceInfoByIndex(index).deviceId, volume: 0)
        }
    
    }
    
    
    /* Starts the playing of the first mp3 file embedded into project */
    func playStreaming() {
        var bundleRoot = NSBundle.mainBundle().bundlePath
        var dirContents: NSArray = NSFileManager.defaultManager().contentsOfDirectoryAtPath(bundleRoot, error: nil)!
        var fltr: NSPredicate = NSPredicate(format: "self ENDSWITH '.mp3'")
        g_mp3Files = dirContents.filteredArrayUsingPredicate(fltr) as! [String]
    
        var assetURL = NSURL.fileURLWithPath(bundleRoot.stringByAppendingPathComponent(g_mp3Files[0]))
        println("NSURL: \(assetURL)")
    
        self.HKWControl.playCAF(assetURL, songName:g_mp3Files[0], resumeFlag:true);
        
        var g_alert = UIAlertController(title: "Playback", message: "Song is currently being played", preferredStyle: .Alert)
        g_alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
            self.dismissViewControllerAnimated(false, completion: nil)
        }))
        self.presentViewController(g_alert, animated: false, completion: nil)

    }
    
    /* Used to determine the volume of the associated beacon to speaker. */
    func changeVolumeBasedOnRange(beacon: CLBeacon) -> Int {
        var volume = 0;
        
        switch (beacon.proximity) {
        case CLProximity.Far: // Should never play at 20 because speaker doesn't play at far range
            break;
        case CLProximity.Near:
            volume = 15;
            break;
        case CLProximity.Immediate:
            volume = 10;
            break;
        case CLProximity.Unknown:
            break;
        default:
            break;
        }
        
        return volume;
    }
    
    /* Polls for kSecondsToPollFor gathering n data points.
     * Calculates the linear regression.
     * Uses to compute the best fit rssi value to base the volume off of. */
   /* func calcAvgAndStream(beacon: CLBeacon, index: Int) {
    
        var setCount: Int!
    
        // Get the number of seconds we've gather data for
        if index == self.superOmniNdx {
            setCount = self.superOmniDataPoints.count
        }
        else {
            setCount = self.smartThingsDataPoints.count
        }
    
        // Has full data set to calculate regression line
        // ... or needs more data point (from 0 to kSecondsToStart)
        if setCount == kSecondsToPollFor {
            self.calculateRegressionLine(index, beacon)
        } else {
            self.initSpeakerPlay(beacon, index, setCount)
        }
    }*/
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
        let detailMessage = "UUID: \(uuid)\nMajor: \(item.majorValue)\nMinor: \(item.minorValue)"
        let detailAlert = UIAlertController(title: "Details", message: detailMessage, preferredStyle: .Alert)
        detailAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
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
        
        // If either ndx hasn't been assign, check to see if they're available.
        if (self.superOmniNdx == -1 || self.smartThingsNdx == -1) {
            self.searchBeacons()
        }
    
        if let beacons = beacons as? [CLBeacon] {
            for beacon in beacons {
                for item in items {
                    if item == beacon {
                        item.lastSeenBeacon = beacon
                        
                        println("Checking which beacon...")
                        
                        if (beacon.minor.isEqualToNumber(kEstimoteOneMinor) && self.superOmniNdx != -1) {
                            println("Playing in SuperOmni...")
                            self.checkBeacon(beacon, index: self.superOmniNdx, rssi: 0)
                            //calcAvgAndStream: beacon speakerNdx:self.superOmniNdx];
                        }
                        
                        if (beacon.major.isEqualToNumber(kWhiteBoxMajor) && self.smartThingsNdx != -1) {
                            println("Playing in SmartThings...")
                            self.checkBeacon(beacon, index: self.smartThingsNdx, rssi: 0)
                            //[self calcAvgAndStream: beacon speakerNdx:self.smartThingsNdx];
                        }
                    }
                }
            }
        }
    }
}

