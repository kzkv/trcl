//
//  MainWindowController.swift
//  trcl
//
//  Created by Tyoma Kazakov on 15.11.2016.
//  Copyright © 2016 Tom Kazakov. All rights reserved.
//

import Cocoa
import ServiceManagement

class MainWindowController: NSWindowController {

    @IBAction func set(sender: NSButton) {
        let appBundleIdentifier = "kzkv.trclAutostartHelper" as CFString
        var autostartValue: Bool
        
        autostartValue = defaults.bool(forKey: autostart)
  
        if SMLoginItemSetEnabled(appBundleIdentifier, autostartValue) {
            if autostartValue {
                NSLog("trcl: Successfully added login item.")
            } else {
                NSLog("trcl: Successfully removed login item.")
            }
            
        } else {
            NSLog("trcl: Failed to add login item.")
        }
    }

}
