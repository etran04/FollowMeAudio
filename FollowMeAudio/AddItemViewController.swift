//
//  AddItemViewController.swift
//  FollowMe
//
//  Created by Eric Tran on 8/27/15.
//  Copyright (c) 2015 Harman International. All rights reserved.
//

import UIKit
import CoreLocation

class AddItemViewController: UITableViewController {
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var uuidTextField: UITextField!
    @IBOutlet weak var majorIdTextField: UITextField!
    @IBOutlet weak var minorIdTextField: UITextField!
  
    var uuidRegex = NSRegularExpression(pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", options: .CaseInsensitive, error: nil)!
    var nameFieldValid = false
    var UUIDFieldValid = false
    var newItem: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveBarButtonItem.enabled = false
    
        nameTextField.addTarget(self, action: "nameTextFieldChanged:", forControlEvents: .EditingChanged)
        uuidTextField.addTarget(self, action: "uuidTextFieldChanged:", forControlEvents: .EditingChanged)
    }
  
    func nameTextFieldChanged(textField: UITextField) {
        nameFieldValid = (count(textField.text) > 0)
        saveBarButtonItem.enabled = (UUIDFieldValid && nameFieldValid)
    }
  
    func uuidTextFieldChanged(textField: UITextField) {
        let numberOfMatches = uuidRegex.numberOfMatchesInString(textField.text, options: nil, range: NSMakeRange(0, count(textField.text)))
        UUIDFieldValid = (numberOfMatches > 0)
    
        saveBarButtonItem.enabled = (UUIDFieldValid && nameFieldValid)
    }
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SaveItemSegue" {
            let uuid = NSUUID(UUIDString: uuidTextField.text)
            let major: CLBeaconMajorValue = UInt16(majorIdTextField.text.toInt()!)
            let minor: CLBeaconMinorValue = UInt16(minorIdTextField.text.toInt()!)
      
            newItem = Item(name: nameTextField.text, uuid: uuid!, majorValue: major, minorValue: minor)
        }
    }
}
